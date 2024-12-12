import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:railway_navigation_app/models/turn_instruction.dart';
import 'package:railway_navigation_app/utils/location_simulator.dart';
import 'package:railway_navigation_app/services/qr_scanner_service.dart';
import 'package:railway_navigation_app/services/text_to_speech_service.dart';

// Model classes
class Vertex {
  final String id;
  final String? objectName;
  final double cx;
  final double cy;

  Vertex({
    required this.id,
    this.objectName,
    required this.cx,
    required this.cy,
  });

  factory Vertex.fromJson(Map<String, dynamic> json) {
    return Vertex(
      id: json['id'],
      objectName: json['objectName'],
      cx: json['cx'].toDouble(),
      cy: json['cy'].toDouble(),
    );
  }
}

class Edge {
  final String id;
  final String from;
  final String to;

  Edge({required this.id, required this.from, required this.to});

  factory Edge.fromJson(Map<String, dynamic> json) {
    return Edge(
      id: json['id'],
      from: json['from'],
      to: json['to'],
    );
  }
}

class PathSegment {
  final String instruction;
  final double distance;
  final String fromId;
  final String toId;

  PathSegment({
    required this.instruction,
    required this.distance,
    required this.fromId,
    required this.toId,
  });
}

class PathPainter extends CustomPainter {
  final List<Vertex> vertices;
  final List<Edge> edges;
  final List<String> path;
  final int currentIndex;
  final double scaleX;
  final double scaleY;

  PathPainter(this.vertices, this.edges, this.path, this.currentIndex, this.scaleX, this.scaleY);

  @override
  void paint(Canvas canvas, Size size) {
    final completedPaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke;

    final upcomingPaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < path.length - 1; i++) {
      final fromVertex = vertices.firstWhere((v) => v.id == path[i]);
      final toVertex = vertices.firstWhere((v) => v.id == path[i + 1]);

      final paint = i <= currentIndex ? completedPaint : upcomingPaint;

      canvas.drawLine(
        Offset(fromVertex.cx * scaleX, fromVertex.cy * scaleY),
        Offset(toVertex.cx * scaleX, toVertex.cy * scaleY),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant PathPainter oldDelegate) {
    return oldDelegate.currentIndex != currentIndex;
  }
}

class EdgesPainter extends CustomPainter {
  final List<Vertex> vertices;
  final List<Edge> edges;
  final double scaleX;
  final double scaleY;

  EdgesPainter(this.vertices, this.edges, this.scaleX, this.scaleY);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    for (var edge in edges) {
      final fromVertex = vertices.firstWhere((v) => v.id == edge.from);
      final toVertex = vertices.firstWhere((v) => v.id == edge.to);

      canvas.drawLine(
        Offset(fromVertex.cx * scaleX, fromVertex.cy * scaleY),
        Offset(toVertex.cx * scaleX, toVertex.cy * scaleY),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant EdgesPainter oldDelegate) {
    return false;
  }
}

// Main MapScreen class
class MapScreen extends StatefulWidget {
  final String selectedStation;

  const MapScreen({
    super.key,
    required this.selectedStation,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<Vertex> vertices = [];
  List<Edge> edges = [];
  String? startPoint;
  String? endPoint;
  List<String> path = [];
  List<String> amenities = [];
  List<PathSegment> pathSegments = [];
  int currentPathIndex = 0;

  // Position tracking
  double? userSvgX;
  double? userSvgY;
  final double waypointReachThreshold = 2.0;

  // Services
  late QRScannerService _qrScannerService;
  late TextToSpeechService _ttsService;

  // State flags
  bool _isNavigating = false;
  bool _hasStartPoint = false;
  String? _lastScannedVertexId;
  Timer? _qrProcessingDebounce;
  bool _showingTurnPrompt = false;
  bool _isFlashlightOn = false;

  @override
  void initState() {
    super.initState();
    _initializeServices();
    loadMapData();
  }

  void _initializeServices() {
    _ttsService = TextToSpeechService();
    _qrScannerService = QRScannerService(onQRCodeScanned: _handleQRCode);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _speakWelcomeMessage();
      Future.delayed(Duration(seconds: 2), () {
        _qrScannerService.startScanning();
      });
    });
  }

  void _speakWelcomeMessage() {
    _ttsService.speak(
      "Welcome to the Railway Station Navigation System. "
      "Please walk along the tactile path. "
      "The app will detect your starting position from QR codes on the ground. "
      "Once detected, double tap anywhere to select your destination.",
    );
  }

  Future<void> loadMapData() async {
    try {
      final String response = await rootBundle.loadString('assets/map_data.json');
      final data = json.decode(response);

      setState(() {
        vertices = (data['vertices'] as List)
            .map((item) => Vertex.fromJson(item))
            .toList();
        edges = (data['edges'] as List)
            .map((item) => Edge.fromJson(item))
            .toList();

        amenities = vertices
            .where((v) => v.objectName != null)
            .map((v) => v.objectName!)
            .toList();
      });
    } catch (e) {
      print('Error loading map data: $e');
      _ttsService.speak("Error loading map data. Please restart the application.");
    }
  }

  void _handleQRCode(String qrCode) {
    _qrProcessingDebounce?.cancel();
    _qrProcessingDebounce = Timer(Duration(milliseconds: 500), () {
      _processQRCode(qrCode);
    });
  }

  void _processQRCode(String qrCode) {
    try {
      final Map<String, dynamic> qrData = json.decode(qrCode);
      final String vertexId = qrData['id'];
      
      if (_lastScannedVertexId == vertexId) return;
      _lastScannedVertexId = vertexId;

      final vertex = vertices.firstWhere(
        (v) => v.id == vertexId,
        orElse: () => throw Exception('Unknown vertex ID: $vertexId'),
      );
      
      setState(() {
        if (!_hasStartPoint) {
          _handleStartPointDetection(vertex);
        } else if (_isNavigating) {
          _updateUserPosition(vertex);
        }
      });
    } catch (e) {
      print('Error processing QR code: $e');
    }
  }

  void _handleStartPointDetection(Vertex vertex) {
    startPoint = vertex.objectName ?? "Point ${vertex.id}";
    _hasStartPoint = true;
    userSvgX = vertex.cx;
    userSvgY = vertex.cy;
    
    _ttsService.speak(
      "Starting point detected at ${vertex.objectName ?? 'Point ${vertex.id}'}. "
      "Double tap anywhere on the screen to select your destination.",
    );
  }

  void _updateUserPosition(Vertex vertex) {
    userSvgX = vertex.cx;
    userSvgY = vertex.cy;

    int nearestIndex = _findNearestPathIndex(vertex.id);
    
    if (nearestIndex != currentPathIndex) {
      currentPathIndex = nearestIndex;
      if (currentPathIndex < pathSegments.length) {
        _speakTurnInstructions(pathSegments[currentPathIndex]);
      } else {
        _handleDestinationReached();
      }
    }
  }

  void _speakTurnInstructions(PathSegment segment) {
    setState(() {
      _showingTurnPrompt = true;
    });

    _ttsService.speak(segment.instruction);
  }

  void _handleDestinationReached() {
    _ttsService.speak(
      "You have reached your destination. Navigation complete. "
      "Double tap anywhere to start a new navigation.",
    );
    setState(() {
      _isNavigating = false;
      _hasStartPoint = false;
      startPoint = null;
      endPoint = null;
      path.clear();
      pathSegments.clear();
      _showingTurnPrompt = false;
    });
  }

  int _findNearestPathIndex(String vertexId) {
    // First check if the vertex is directly in our path
    for (int i = currentPathIndex; i < path.length; i++) {
      if (path[i] == vertexId) return i;
    }

    // If not found directly, find the nearest vertex in the remaining path
    Vertex currentVertex = vertices.firstWhere((v) => v.id == vertexId);
    double minDistance = double.infinity;
    int nearestIndex = currentPathIndex;

    for (int i = currentPathIndex; i < path.length; i++) {
      Vertex pathVertex = vertices.firstWhere((v) => v.id == path[i]);
      double distance = _calculateDistance(currentVertex.id, pathVertex.id);
      
      if (distance < minDistance) {
        minDistance = distance;
        nearestIndex = i;
      }
    }

    // If we're very close to the next waypoint, move to it
    if (minDistance < waypointReachThreshold) {
      return nearestIndex;
    }

    // Otherwise stay at current index
    return currentPathIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Full screen camera
          Positioned.fill(
            child: _qrScannerService.buildQRScanner(),
          ),

          // Flashlight toggle button
          Positioned(
            top: 40,
            right: 16,
            child: Semantics(
              button: true,
              label: _isFlashlightOn ? 'Turn off flashlight' : 'Turn on flashlight',
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isFlashlightOn = !_isFlashlightOn;
                    _qrScannerService.toggleFlashlight(_isFlashlightOn);
                    _ttsService.speak(_isFlashlightOn ? 'Flashlight turned on' : 'Flashlight turned off');
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Icon(
                    _isFlashlightOn ? Icons.flash_on : Icons.flash_off,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ),
          ),

          // Invisible button for double tap
          Positioned.fill(
            child: GestureDetector(
              onDoubleTap: _showDestinationSelector,
              behavior: HitTestBehavior.translucent,
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),

          // Current instruction display
          if (_isNavigating && currentPathIndex < pathSegments.length)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Instruction:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(pathSegments[currentPathIndex].instruction),
                      if (currentPathIndex + 1 < pathSegments.length)
                        Text(
                          'Next: ${pathSegments[currentPathIndex + 1].instruction}',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showDestinationSelector() {
    if (!_hasStartPoint) {
      _ttsService.speak(
        "Please wait while we detect your starting position from a QR code.",
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('Select Destination'),
        children: amenities.map((amenity) => SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context);
            _setDestination(amenity);
          },
          child: Semantics(
            label: amenity,
            button: true,
            child: Text(
              amenity,
              style: TextStyle(fontSize: 18),
            ),
          ),
        )).toList(),
      ),
    ).then((_) {
      if (endPoint == null) {
        _ttsService.speak(
          "Double tap on your desired destination when ready.",
        );
      }
    });
  }

  void _setDestination(String destination) {
    setState(() {
      endPoint = destination;
      _ttsService.speak(
        "Destination set to $destination. Starting navigation. "
        "Please follow the tactile path and keep your phone pointed downward to scan QR codes.",
      );
      _calculateRoute();
      _isNavigating = true;
    });
  }

  void _calculateRoute() {
    if (startPoint == null || endPoint == null) return;

    String? startId = _getVertexIdFromAmenity(startPoint!);
    String? endId = _getVertexIdFromAmenity(endPoint!);

    if (startId != null && endId != null) {
      setState(() {
        path = _findPath(startId, endId);
        pathSegments = _generatePathSegments(path);
        currentPathIndex = 0;
        
        if (pathSegments.isNotEmpty) {
          _speakTurnInstructions(pathSegments[0]);
        }
      });
    }
  }

  String? _getVertexIdFromAmenity(String amenityName) {
    try {
      return vertices.firstWhere((v) => v.objectName == amenityName).id;
    } catch (e) {
      print('Error finding vertex for amenity $amenityName: $e');
      return null;
    }
  }

  List<String> _findPath(String start, String end) {
    Map<String, double> distances = {};
    Map<String, String> previous = {};
    Set<String> unvisited = {};

    for (var vertex in vertices) {
      distances[vertex.id] = double.infinity;
      unvisited.add(vertex.id);
    }
    distances[start] = 0;

    while (unvisited.isNotEmpty) {
      String current = unvisited.reduce((a, b) => 
        distances[a]! < distances[b]! ? a : b
      );

      if (current == end) break;

      unvisited.remove(current);

      for (var edge in edges.where((e) => e.from == current || e.to == current)) {
        String neighbor = edge.from == current ? edge.to : edge.from;
        if (!unvisited.contains(neighbor)) continue;

        double distance = _calculateDistance(current, neighbor);
        double totalDistance = distances[current]! + distance;

        if (totalDistance < distances[neighbor]!) {
          distances[neighbor] = totalDistance;
          previous[neighbor] = current;
        }
      }
    }

    List<String> path = [];
    String? current = end;
    while (current != null) {
      path.insert(0, current);
      current = previous[current];
    }

    return path;
  }

  double _calculateDistance(String fromId, String toId) {
    Vertex from = vertices.firstWhere((v) => v.id == fromId);
    Vertex to = vertices.firstWhere((v) => v.id == toId);
    return math.sqrt(math.pow(to.cx - from.cx, 2) + math.pow(to.cy - from.cy, 2));
  }

  List<PathSegment> _generatePathSegments(List<String> path) {
    List<PathSegment> segments = [];
    
    for (int i = 0; i < path.length - 1; i++) {
      Vertex current = vertices.firstWhere((v) => v.id == path[i]);
      Vertex next = vertices.firstWhere((v) => v.id == path[i + 1]);
      
      String instruction = _generateInstruction(current, next, i == 0);
      double distance = _calculateDistance(current.id, next.id);
      
      segments.add(PathSegment(
        instruction: instruction,
        distance: distance,
        fromId: current.id,
        toId: next.id,
      ));
    }
    
    return segments;
  }

  String _generateInstruction(Vertex current, Vertex next, bool isFirst) {
    String nextName = next.objectName ?? "next point";
    String currentName = current.objectName ?? "current point";
    
    if (isFirst) {
      return "Start walking along the tactile path towards $nextName";
    }
    
    String turnType = _determineTurnType(current, next);
    String direction = _getDirectionFromTurnType(turnType);
    
    if (next.objectName != null) {
      return "Follow the tactile path $direction to reach $nextName";
    } else {
      return "Follow the tactile path $direction";
    }
  }

  String _getDirectionFromTurnType(String turnType) {
    switch (turnType) {
      case "west_flyover_down":
        return "left and down the ramp";
      case "east_flyover_down":
        return "right and down the ramp";
      case "west_flyover_up":
        return "left and up the ramp";
      case "east_flyover_up":
        return "right and up the ramp";
      case "platform1_corridor":
      case "platform2_corridor":
        return "straight ahead along the platform";
      default:
        return "straight ahead";
    }
  }

  String _determineTurnType(Vertex current, Vertex next) {
    double dx = next.cx - current.cx;
    double dy = next.cy - current.cy;

    if (current.cy < 200) {
      if (current.cx < 100 && next.cy > current.cy) {
        return "west_flyover_down";
      }
      if (current.cx > 900 && next.cy > current.cy) {
        return "east_flyover_down";
      }
      if (dx.abs() > dy.abs()) {
        return "platform1_corridor";
      }
    }

    if (current.cy > 300) {
      if (current.cx < 100 && next.cy < current.cy) {
        return "west_flyover_up";
      }
      if (current.cx > 900 && next.cy < current.cy) {
        return "east_flyover_up";
      }
      if (dx.abs() > dy.abs()) {
        return "platform2_corridor";
      }
    }

    if (current.cy > 200 && current.cy < 300) {
      if (current.cx < 100) return "west_flyover_middle";
      if (current.cx > 900) return "east_flyover_middle";
    }

    return "general_corridor";
  }

  @override
  void dispose() {
    _qrScannerService.dispose();
    _ttsService.dispose();
    _qrProcessingDebounce?.cancel();
    super.dispose();
  }
}