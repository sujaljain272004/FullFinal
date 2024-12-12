import 'dart:async';
import 'dart:math';

class LocationSimulator {
  final Function(double, double) onLocationUpdate;
  Timer? _simulationTimer;
  double? _targetX;
  double? _targetY;
  double? _currentX;
  double? _currentY;
  static const double STEP_SIZE = 2.0; // Adjust this value to control movement speed

  LocationSimulator({required this.onLocationUpdate});

  void startSimulation(double targetX, double targetY) {
    _targetX = targetX;
    _targetY = targetY;
    
    // Initialize current position if not set
    _currentX ??= targetX;
    _currentY ??= targetY;

    _simulationTimer?.cancel();
    _simulationTimer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      if (_currentX == null || _currentY == null) return;

      // Calculate direction vector
      double dx = _targetX! - _currentX!;
      double dy = _targetY! - _currentY!;
      
      // Calculate distance to target
      double distance = sqrt(dx * dx + dy * dy);
      
      if (distance < STEP_SIZE) {
        // Reached target
        _currentX = _targetX;
        _currentY = _targetY;
        onLocationUpdate(_currentX!, _currentY!);
        timer.cancel();
      } else {
        // Normalize direction and move by step size
        double normalizedDx = dx / distance;
        double normalizedDy = dy / distance;
        
        _currentX = _currentX! + normalizedDx * STEP_SIZE;
        _currentY = _currentY! + normalizedDy * STEP_SIZE;
        
        onLocationUpdate(_currentX!, _currentY!);
      }
    });
  }

  void stopSimulation() {
    _simulationTimer?.cancel();
    _simulationTimer = null;
  }
}