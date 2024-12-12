import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:railway_navigation_app/utils/user_pointer_painter.dart';
import 'package:railway_navigation_app/models/turn_instruction.dart';
import 'package:railway_navigation_app/utils/location_simulator.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:railway_navigation_app/models/train_coach_mapping.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mobile_scanner/src/objects/barcode.dart';  // Add this import

class MapScreens extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreens> with TickerProviderStateMixin {
  List<Vertex> vertices = [];
  List<Edge> edges = [];
  String? startPoint;
  String? endPoint;
  List<String> path = [];
  List<String> amenities = [];
  List<String> navigationInstructions = [];
  static const double METERS_PER_UNIT =
      0.5; // Each coordinate unit = 0.5 meters
  int currentPathIndex = 0;
  List<PathSegment> pathSegments = [];
  late LocationSimulator locationSimulator;
  double? currentSvgX;
  double? currentSvgY;
  double? userSvgX;
  double? userSvgY;
  final double waypointReachThreshold = 2.0; // meters
  bool showingTurnPrompt = false;
  List<TurnInstruction> turnInstructions = [];
  double? _lastUserX;
  double? _lastUserY;
  double _simulationProgress = 0.0;
  bool _isSimulating = false;
  Timer? _simulationTimer;
  final double SIMULATION_SPEED = 0.01; // 2% of segment per tick
  late FlutterTts flutterTts;
  bool isSpeaking = false;
  String? trainNumber;
  String? coachNumber;
  String? targetCoachArea;
  bool _showCrowdAnalysis = false; // State for toggle button
  String svgData = ''; // To hold the heatmap SVG data
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // Create a class to hold path segment information

  @override
  void initState() {
    super.initState();
    locationSimulator = LocationSimulator(onLocationUpdate: (x, y) {
      setState(() {
        userSvgX = x;
        userSvgY = y;
      });
    });
    loadMapData();
    _initTts();
  }

  Future<void> loadMapData() async {
    try {
      final String response =
          await rootBundle.loadString('assets/map_data.json');
      final data = json.decode(response);

      setState(() {
        vertices = (data['vertices'] as List)
            .map((item) => Vertex.fromJson(item))
            .toList();
        edges =
            (data['edges'] as List).map((item) => Edge.fromJson(item)).toList();

        // Extract amenities for dropdown (excluding null values)
        amenities = vertices
            .where((v) => v.objectName != null)
            .map((v) => v.objectName!)
            .toList();
      });
    } catch (e) {
      print('Error loading map data: $e');
    }
  }

  // Calculate actual edge distance between two connected vertices
  double calculateEdgeDistance(String fromId, String toId) {
    // Skip distance calculation for v19 to coach area 1
    if (fromId == 'v19' &&
        vertices
                .firstWhere((v) => v.id == toId)
                .objectName
                ?.contains('Coach Area 1') ==
            true) {
      return 0.0;
    }

    Vertex from = vertices.firstWhere((v) => v.id == fromId);
    Vertex to = vertices.firstWhere((v) => v.id == toId);

    double distance =
        math.sqrt(math.pow(to.cx - from.cx, 2) + math.pow(to.cy - from.cy, 2)) *
            METERS_PER_UNIT;

    // Comment out or remove this line to stop printing
    // print('Edge distance from $fromId to $toId: ${distance.toStringAsFixed(1)} meters');
    return distance;
  }

  // ... existing code ...

  List<String> findPath(String start, String end) {
    Map<String, double> distances = {};
    Map<String, String?> previous = {};
    Set<String> unvisited = {};

    // Initialize distances
    for (var vertex in vertices) {
      distances[vertex.id] = double.infinity;
      unvisited.add(vertex.id);
    }
    distances[start] = 0;

    while (unvisited.isNotEmpty) {
      // Find unvisited vertex with smallest distance
      String? current = null;
      double minDistance = double.infinity;

      for (var id in unvisited) {
        if (distances[id]! < minDistance) {
          current = id;
          minDistance = distances[id]!;
        }
      }

      if (current == null || current == end) break;

      unvisited.remove(current);

      // Get all connected edges for current vertex
      List<Edge> currentEdges = edges
          .where((edge) => edge.from == current || edge.to == current)
          .toList();

      // Process each neighbor
      for (var edge in currentEdges) {
        String neighbor = edge.from == current ? edge.to : edge.from;
        if (!unvisited.contains(neighbor)) continue;

        // Calculate actual distance between vertices
        double edgeDistance = calculateDistance(current, neighbor);
        double totalDistance = distances[current]! + edgeDistance;

        if (totalDistance < distances[neighbor]!) {
          distances[neighbor] = totalDistance;
          previous[neighbor] = current;
          print('Updated path: $current -> $neighbor = $totalDistance units');
        }
      }
    }

    // Reconstruct path
    List<String> path = [];
    String? current = end;

    while (current != null) {
      path.insert(0, current);
      current = previous[current];
    }

    // Validate and print the path
    if (path.length < 2 || path.first != start || path.last != end) {
      print('Warning: Invalid path generated');
      return [];
    }

    // Print total path distance
    double totalDistance = 0;
    for (int i = 0; i < path.length - 1; i++) {
      double segmentDistance = calculateDistance(path[i], path[i + 1]);
      totalDistance += segmentDistance;
      print('Segment ${path[i]} -> ${path[i + 1]}: $segmentDistance units');
    }
    print('Total path distance: $totalDistance units');

    return path;
  }

// Remove all other calculateDistance functions and keep only this one
  double calculateDistance(String fromId, String toId) {
    // Skip distance calculation for v19 to coach area 1
    if (fromId == 'v19' &&
        vertices
                .firstWhere((v) => v.id == toId)
                .objectName
                ?.contains('Coach Area 1') ==
            true) {
      return 0.0;
    }

    Vertex from = vertices.firstWhere((v) => v.id == fromId);
    Vertex to = vertices.firstWhere((v) => v.id == toId);

    // Calculate actual distance along the edge
    double distance =
        math.sqrt(math.pow(to.cx - from.cx, 2) + math.pow(to.cy - from.cy, 2));

    // Comment out or remove this line to stop printing
    // print('Distance from $fromId to $toId: ${distance.toStringAsFixed(1)} units');
    return distance;
  }

  String? getVertexIdFromAmenity(String amenityName) {
    try {
      return vertices.firstWhere((v) => v.objectName == amenityName).id;
    } catch (e) {
      print('Error finding vertex for amenity $amenityName: $e');
      return null;
    }
  }

  // Modify the generateNavigationInstructions method
  List<PathSegment> generatePathSegments(List<String> path) {
    List<PathSegment> segments = [];

    for (int i = 0; i < path.length - 1; i++) {
      String currentId = path[i];
      String nextId = path[i + 1];

      Vertex current = vertices.firstWhere((v) => v.id == currentId);
      Vertex next = vertices.firstWhere((v) => v.id == nextId);
      Vertex? prev =
          i > 0 ? vertices.firstWhere((v) => v.id == path[i - 1]) : null;

      String nextName = next.objectName ?? 'Point ${next.id}';

      TurnInstruction turnInstruction = TurnInstruction.createFromVertex(
        vertexId: current.id,
        objectName: current.objectName,
        nextDestination: nextName,
        cx: current.cx,
        cy: current.cy,
        isFirstInstruction: i == 0,
        nextCx: next.cx,
        nextCy: next.cy,
        prevCx: prev?.cx,
        prevCy: prev?.cy,
      );

      segments.add(PathSegment(
        instruction: turnInstruction.instruction,
        distance: calculateDistance(current.id, next.id) * METERS_PER_UNIT,
        fromId: current.id,
        toId: next.id,
      ));
    }

    return segments;
  }

  // Modify updatePath to use the new PathSegment system
  void updatePath() {
    if (startPoint == null || endPoint == null) return;

    try {
      // Find start and end vertices
      Vertex start = vertices.firstWhere(
        (v) => v.objectName == startPoint,
      );

      Vertex end = vertices.firstWhere(
        (v) => v.objectName == endPoint,
      );

      print("Start vertex: ${start.id}, End vertex: ${end.id}");

      // Generate path (now using IDs)
      List<String> pathIds = findPath(start.id, end.id);
      print("Path length: ${pathIds.length}");

      // Update both path and pathSegments
      path = pathIds;
      pathSegments = generatePathSegments(pathIds);
      currentPathIndex = 0;

      setState(() {});
    } catch (e) {
      print("Error finding path: $e");
    }
  }

  // Add method to get current visible path
  List<String> getCurrentVisiblePath() {
    if (_isSimulating) {
      return path; // Show full path during navigation
    }
    return path.sublist(
        0,
        currentPathIndex + 2 > path.length
            ? path.length
            : currentPathIndex + 2);
  }

  void startNavigation() {
    if (pathSegments.isEmpty) return;

    setState(() {
      currentPathIndex = 0;
      _simulationProgress = 0.0;
      _isSimulating = true;

      Vertex startVertex =
          vertices.firstWhere((v) => v.id == pathSegments[0].fromId);
      currentSvgX = startVertex.cx;
      currentSvgY = startVertex.cy;
    });

    // Speak initial navigation instruction
    _speakInstruction("Starting navigation. ${pathSegments[0].instruction}");

    _startPathSimulation();
  }

  void _startPathSimulation() {
    _simulationTimer?.cancel();
    _simulationTimer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      if (!_isSimulating || currentPathIndex >= pathSegments.length) {
        timer.cancel();
        return;
      }

      setState(() {
        _simulationProgress += SIMULATION_SPEED;

        // Update pointer position
        PathSegment currentSegment = pathSegments[currentPathIndex];
        Vertex fromVertex =
            vertices.firstWhere((v) => v.id == currentSegment.fromId);
        Vertex toVertex =
            vertices.firstWhere((v) => v.id == currentSegment.toId);

        currentSvgX =
            fromVertex.cx + (toVertex.cx - fromVertex.cx) * _simulationProgress;
        currentSvgY =
            fromVertex.cy + (toVertex.cy - fromVertex.cy) * _simulationProgress;

        // If reached end of current segment
        if (_simulationProgress >= 1.0) {
          _simulationTimer?.cancel();
          _showTurnConfirmationDialog();
        }
      });
    });
  }

  void _showTurnConfirmationDialog() {
    bool isMinimized = false;
    OverlayEntry? overlayEntry;

    void showMinimizedButton() {
      overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton.extended(
            onPressed: () {
              overlayEntry?.remove();
              _showTurnConfirmationDialog();
            },
            backgroundColor: Colors.blue,
            icon: Icon(Icons.navigation, color: Colors.white),
            label: Text(
              'Show Navigation',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      );

      Overlay.of(context).insert(overlayEntry!);
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String currentVertexId = pathSegments[currentPathIndex].toId;
        Vertex currentVertex =
            vertices.firstWhere((v) => v.id == currentVertexId);

        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Check Your Surroundings',
            style: TextStyle(color: Colors.black),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  TurnInstruction.getVertexImage(currentVertex.id),
                  height: 150,
                ),
                SizedBox(height: 16),
                Text('Does this match what you see?'),
                if (currentPathIndex < pathSegments.length - 1) ...[
                  SizedBox(height: 16),
                  Text(
                    'Next: ${pathSegments[currentPathIndex + 1].instruction}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.blue[700],
                    ),
                  ),
                ],
                SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    if (currentPathIndex < pathSegments.length - 1) {
                      _speakInstruction(
                          pathSegments[currentPathIndex + 1].instruction);
                    }
                  },
                  icon: Icon(Icons.volume_up),
                  label: Text('Play Voice Instruction'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                showMinimizedButton();
              },
              child: Text('Not Yet'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                if (overlayEntry != null) {
                  overlayEntry?.remove();
                }
                setState(() {
                  if (currentPathIndex < pathSegments.length - 1) {
                    currentPathIndex++;
                    _simulationProgress = 0.0;
                    _isSimulating = true;
                    _startPathSimulation();
                    // Speak the next instruction after confirmation
                    _speakInstruction(
                        pathSegments[currentPathIndex].instruction);
                  } else {
                    _showDestinationReachedDialog();
                  }
                });
              },
              child: Text('Yes, I\'m Here'),
            ),
          ],
        );
      },
    );
  }

  String _getTurnImageAsset() {
    if (currentPathIndex >= pathSegments.length - 1) {
      // Get the vertex ID for the end point
      String? endVertexId =
          vertices.firstWhere((v) => v.objectName == endPoint).id;
      return TurnInstruction.getVertexImage(endVertexId);
    }

    // Get current vertex ID
    String currentVertexId = pathSegments[currentPathIndex].fromId;
    return TurnInstruction.getVertexImage(currentVertexId);
  }

  void _showDestinationReachedDialog() {
    String reachedMessage = 'You have arrived at ${endPoint}';
    _speakInstruction(reachedMessage);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Destination Reached'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(reachedMessage),
              SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  _speakInstruction(reachedMessage);
                },
                icon: Icon(Icons.volume_up),
                label: Text('Replay Voice Message'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    flutterTts.stop();
    locationSimulator.stopSimulation();
    super.dispose();
  }

  // Update the UI to show current location and progress
  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final size = MediaQuery.of(context).size;

    Widget mapContent = Stack(
      children: [
        InteractiveViewer(
          boundaryMargin: EdgeInsets.all(20.0),
          minScale: 0.5,
          maxScale: 4.0,
          child: Center(
            child: Container(
              width: 1000,
              height: 600,
              child: Stack(
                children: [
                  SvgPicture.asset(
                    'assets/station_map.svg',
                    fit: BoxFit.fill,
                  ),
                  if (_showCrowdAnalysis && svgData.isNotEmpty)
                    SvgPicture.string(svgData), // Render heatmap if toggled on
                  CustomPaint(
                    size: Size(1000, 600),
                    painter: PathPainter(
                      vertices,
                      edges,
                      getCurrentVisiblePath(),
                    ),
                  ),
                  if (currentSvgX != null && currentSvgY != null)
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return CustomPaint(
                          size: Size(1000, 600),
                          painter: UserPointerPainter(
                            currentSvgX!,
                            currentSvgY!,
                            constraints.maxWidth / 1000,
                            constraints.maxHeight / 600,
                            0.0,
                            isNearWaypoint: false,
                            isOffRoute: false,
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
        // Add the toggle button for crowd congestion analysis
        Positioned(
          top: 20, // Adjust position as needed
          right: 20, // Adjust position as needed
          child: Row(
            children: [
              Text(
                'Crowd Analysis',
                style: TextStyle(color: Colors.black),
              ),
              Switch(
                value: _showCrowdAnalysis,
                onChanged: (value) {
                  setState(() {
                    _showCrowdAnalysis = value;
                    if (_showCrowdAnalysis) {
                      fetchHeatmap(); // Fetch heatmap data when toggled on
                    } else {
                      svgData = ''; // Clear heatmap data when toggled off
                    }
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );

    Widget mainContent = Column(
      children: [
        // Start and End point dropdowns
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              hint: Text('Select Start Point',
                                  style: TextStyle(color: Colors.black)),
                              value: startPoint,
                              isExpanded: true,
                              icon: Icon(Icons.location_on, color: Colors.blue),
                              dropdownColor: Colors.white,
                              items: amenities.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    startPoint = newValue;
                                    updatePath();
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                      // Add QR Scanner button
                      IconButton(
                        icon: Icon(Icons.qr_code_scanner, color: Colors.blue),
                        onPressed: _startQRScan,
                        tooltip: 'Scan QR Code for Start Point',
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        hint: Text('Select End Point',
                            style: TextStyle(color: Colors.black)),
                        value: endPoint,
                        isExpanded: true,
                        icon: Icon(Icons.flag, color: Colors.red),
                        dropdownColor: Colors.white,
                        items: amenities.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value,
                                style: TextStyle(color: Colors.black)),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            endPoint = newValue;
                            updatePath();
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Train details input
        _buildTicketInput(),
        SizedBox(height: 16),

        // Navigation info and start button
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.directions_walk, color: Colors.blue[700]),
                        SizedBox(width: 8),
                        Text(
                          'Current Navigation Step:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.blue[700],
                          ),
                        ),
                      ],
                    ),
                    // Add distance chip
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.blue[200]!),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.straighten,
                              size: 16, color: Colors.blue[700]),
                          SizedBox(width: 4),
                          Text(
                            calculateTotalDistance(),
                            style: TextStyle(
                              color: Colors.blue[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (pathSegments.isNotEmpty) ...[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      pathSegments[currentPathIndex].instruction,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Step ${currentPathIndex + 1}/${pathSegments.length}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: startNavigation,
                  icon: Icon(Icons.navigation),
                  label: Text(
                    'Start Navigation',
                    style: TextStyle(color: Colors.black),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 16),
        // Map content
        orientation == Orientation.landscape
            ? Container(
                height: size.height - 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: mapContent,
                ),
              )
            : Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: mapContent,
                ),
              ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue[700],
        title: Row(
          children: [
            Icon(Icons.train, size: 24),
            SizedBox(width: 12),
            Text(
              'Railway Station Navigation',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
      ),
      body: orientation == Orientation.landscape
          ? SingleChildScrollView(
              child: mainContent,
            )
          : mainContent,
    );
  }

  void _generateTurnInstructions() {
    turnInstructions.clear();

    for (int i = 0; i < path.length - 1; i++) {
      String currentVertexId = path[i];
      String nextVertexId = path[i + 1];

      Vertex currentVertex =
          vertices.firstWhere((v) => v.id == currentVertexId);
      Vertex nextVertex = vertices.firstWhere((v) => v.id == nextVertexId);

      turnInstructions.add(TurnInstruction.createFromVertex(
        vertexId: currentVertexId,
        objectName: currentVertex.objectName,
        nextDestination: nextVertex.objectName ?? "next point",
        cx: currentVertex.cx,
        cy: currentVertex.cy,
        isFirstInstruction: i == 0,
        nextCx: nextVertex.cx,
        nextCy: nextVertex.cy,
      ));
    }
  }

  // Add this helper method to check if a vertex is a flyover
  bool isFlyoverVertex(Vertex vertex) {
    return (vertex.cx < 100 || vertex.cx > 900) &&
        (vertex.cy > 190 && vertex.cy < 310);
  }

  // Helper method to determine if a vertex is a significant turning point
  bool _isSignificantTurningPoint(Vertex vertex) {
    // Add logic to identify important turning points based on coordinates
    // For example, vertices near platform changes, corridor intersections, etc.
    return vertex.objectName == null &&
        (
            // West flyover points
            (vertex.cx < 100 && vertex.cy > 190 && vertex.cy < 310) ||
                // East flyover points
                (vertex.cx > 900 && vertex.cy > 190 && vertex.cy < 310) ||
                // Other significant turning points
                _isNearPlatformChange(vertex));
  }

  String _determineTurnType(Vertex current, Vertex next) {
    // Calculate direction change
    double dx = next.cx - current.cx;
    double dy = next.cy - current.cy;

    // Platform 1 area (y < 200)
    if (current.cy < 200) {
      // West flyover going down
      if (current.cx < 100 && next.cy > current.cy) {
        return "west_flyover_down";
      }
      // East flyover going down
      if (current.cx > 900 && next.cy > current.cy) {
        return "east_flyover_down";
      }
      // Moving along Platform 1
      if (dx.abs() > dy.abs()) {
        return "platform1_corridor";
      }
    }

    // Platform 2 area (y > 300)
    if (current.cy > 300) {
      // West flyover going up
      if (current.cx < 100 && next.cy < current.cy) {
        return "west_flyover_up";
      }
      // East flyover going up
      if (current.cx > 900 && next.cy < current.cy) {
        return "east_flyover_up";
      }
      // Moving along Platform 2
      if (dx.abs() > dy.abs()) {
        return "platform2_corridor";
      }
    }

    // Middle area (flyover transitions)
    if (current.cy > 200 && current.cy < 300) {
      if (current.cx < 100) return "west_flyover_middle";
      if (current.cx > 900) return "east_flyover_middle";
    }

    return "general_corridor";
  }

  void _handleWaypointReached() {
    if (currentPathIndex < pathSegments.length - 1) {
      setState(() {
        showingTurnPrompt = true;
        // Start moving to next waypoint using SVG coordinates
        Vertex nextTarget = vertices
            .firstWhere((v) => v.id == pathSegments[currentPathIndex + 1].toId);
        locationSimulator.startSimulation(nextTarget.cx, nextTarget.cy);
      });
    } else {
      // Reached final destination
      setState(() {
        showingTurnPrompt = true;
        locationSimulator.stopSimulation();
      });
    }
  }

  bool _isNearPlatformChange(Vertex vertex) {
    // Check if vertex is near platform transition areas

    // Near west flyover
    if (vertex.cx < 100) {
      return vertex.cy > 190 && vertex.cy < 310; // Between platforms
    }

    // Near east flyover
    if (vertex.cx > 900) {
      return vertex.cy > 190 && vertex.cy < 310; // Between platforms
    }

    return false; // Not near any platform change point
  }

  // Initialize TTS
  Future<void> _initTts() async {
    flutterTts = FlutterTts();
    await flutterTts.setLanguage("en-US");

    // Try to set a female voice
    await flutterTts
        .setVoice({"name": "en-us-x-sfg#female_1-local", "locale": "en-US"});

    // Increase speech rate from 0.5 to 0.8 for more natural speed
    await flutterTts.setSpeechRate(0.8);

    // Slightly higher pitch for female voice
    await flutterTts.setPitch(1.5);

    await flutterTts.setVolume(1.0);
  }

  // Speak instruction
  Future<void> _speakInstruction(String text) async {
    if (isSpeaking) {
      await flutterTts.stop();
    }
    setState(() => isSpeaking = true);
    await flutterTts.speak(text);
    setState(() => isSpeaking = false);
  }

  // Add method to handle ticket input
  void processTicketInfo(String trainNo, String coachNo) {
    setState(() {
      trainNumber = trainNo;
      coachNumber = coachNo;

      // Get coach area mapping
      TrainCoachMapping? mapping = trainMappings[trainNo];
      if (mapping != null) {
        // Get vertex ID for the coach area
        String vertexId = mapping.getVertexId(coachNo);

        try {
          // Find the vertex object
          Vertex targetVertex = vertices.firstWhere(
            (v) => v.id == vertexId,
          );

          // Set the end point to the coach area's objectName
          endPoint = targetVertex.objectName;
          print("Selected coach area: ${targetVertex.objectName}");

          // Force path update
          if (startPoint != null) {
            updatePath();
          }
        } catch (e) {
          print('Error finding vertex for coach: $e');
        }
      }
    });
  }

  // Add UI for ticket input
  Widget _buildTicketInput() {
    // Extract train numbers and coach numbers for dropdowns
    List<String> trainNumbers = trainMappings.keys.toList();
    List<String> coachNumbers = trainNumber != null
        ? trainMappings[trainNumber]!.coachToAreaMap.keys.toList()
        : [];

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Add heading text
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Row(
              children: [
                Icon(Icons.train, color: Colors.blue[700]),
                SizedBox(width: 8),
                Text(
                  'Want to navigate to your coach?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue[700],
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        hint: Text('Select Train Number',
                            style: TextStyle(color: Colors.black)),
                        value: trainNumber,
                        isExpanded: true,
                        icon: Icon(Icons.train, color: Colors.blue),
                        dropdownColor: Colors.white,
                        items: trainNumbers.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value,
                                style: TextStyle(color: Colors.black)),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            trainNumber = newValue;
                            coachNumber =
                                null; // Reset coach number when train changes
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        hint: Text('Select Coach Number',
                            style: TextStyle(color: Colors.black)),
                        value: coachNumber,
                        isExpanded: true,
                        icon: Icon(Icons.chair, color: Colors.red),
                        dropdownColor: Colors.white,
                        items: coachNumbers.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value,
                                style: TextStyle(color: Colors.black)),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            coachNumber = newValue;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  if (trainNumber != null && coachNumber != null) {
                    processTicketInfo(trainNumber!, coachNumber!);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  textStyle: TextStyle(color: Colors.black),
                ),
                child: Text(
                  'Find Coach',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String calculateTotalDistance() {
    if (pathSegments.isEmpty) return "0 m";

    double totalDistance = pathSegments.fold(
        0.0,
        (sum, segment) =>
            sum +
            calculateDistance(segment.fromId, segment.toId) * METERS_PER_UNIT);

    if (totalDistance >= 1000) {
      return "${(totalDistance / 1000).toStringAsFixed(2)} km";
    } else {
      return "${totalDistance.toStringAsFixed(1)} m";
    }
  }

  Future<void> fetchHeatmap() async {
    try {
      final response =
          await http.get(Uri.parse('http://crowd.pravaah.xyz/heatmap'));
      if (response.statusCode == 200) {
        setState(() {
          svgData = response.body;
        });
        print('Heatmap SVG Data: $svgData'); // Debug print
      } else {
        print('Failed to load heatmap: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching heatmap: $e');
    }
  }

  void _startQRScan() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            height: 400,
            child: Column(
              children: [
                AppBar(
                  title: Text('Scan QR Code'),
                  leading: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: MobileScanner(
                    controller: MobileScannerController(),
                    onDetect: (capture) {
                      final List<Barcode> barcodes = capture.barcodes;
                      for (final barcode in barcodes) {
                        if (barcode.rawValue != null) {
                          _processQRCode(barcode.rawValue!);
                          Navigator.pop(context);
                        }
                      }
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Scan QR Code to set starting point',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Hold the camera steady over the QR code',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _processQRCode(String code) {
    print('Processing QR code: $code');
    
    try {
      // Parse the QR code data
      Map<String, dynamic> qrData = json.decode(code);
      String? scannedVertexId = qrData['vertexId'];
      
      if (scannedVertexId == null) {
        throw Exception('No vertex ID found in QR code');
      }
      
      print('Scanned vertex ID: $scannedVertexId');
      
      // Find the vertex in our loaded map data
      Vertex? matchingVertex = vertices.firstWhere(
        (vertex) => vertex.id == scannedVertexId,
        orElse: () => throw Exception('Vertex ID not found in map data'),
      );
      
      // Get the amenity name from the vertex
      String? amenityName = matchingVertex.objectName;
      if (amenityName == null || amenityName.isEmpty) {
        throw Exception('No amenity name associated with this location');
      }
      
      // Set the starting point
      setState(() {
        startPoint = amenityName;
        updatePath();
      });
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Starting point set to: $amenityName'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      
    } catch (e) {
      print('Error processing QR code: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid QR code format'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
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

class PathPainter extends CustomPainter {
  final List<Vertex> vertices;
  final List<Edge> edges;
  final List<String> path;

  PathPainter(this.vertices, this.edges, this.path);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    // Calculate scale factors based on the container size vs original SVG size
    final scaleX = size.width / 1000;
    final scaleY = size.height / 600;

    for (int i = 0; i < path.length - 1; i++) {
      final fromVertex = vertices.firstWhere((v) => v.id == path[i]);
      final toVertex = vertices.firstWhere((v) => v.id == path[i + 1]);

      // Scale the coordinates according to the current container size
      final from = Offset(
        fromVertex.cx * scaleX,
        fromVertex.cy * scaleY,
      );
      final to = Offset(
        toVertex.cx * scaleX,
        toVertex.cy * scaleY,
      );

      canvas.drawLine(from, to, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
