import 'dart:math' as math;

class TurnInstruction {
  final String instruction;
  final String confirmationText;
  final String imagePath;
  final double cx;
  final double cy;

  TurnInstruction({
    required this.instruction,
    required this.confirmationText,
    required this.imagePath,
    required this.cx,
    required this.cy,
  });

  static TurnInstruction createFromVertex({
    required String vertexId,
    required String? objectName,
    required String nextDestination,
    required double cx,
    required double cy,
    required bool isFirstInstruction,
    required double nextCx,
    required double nextCy,
    double? prevCx,
    double? prevCy,
  }) {
    String instruction;
    String confirmationText = "Are you on the right path?";

    if (isFirstInstruction) {
      double dx = nextCx - cx;
      double dy = nextCy - cy;
      instruction = _getInitialDirectionInstruction(dx, dy, nextDestination);
    } else if (prevCx != null && prevCy != null) {
      double angleChange = _calculateAngleChange(
        prevCx: prevCx,
        prevCy: prevCy,
        currentX: cx,
        currentY: cy,
        nextX: nextCx,
        nextY: nextCy
      );

      if (angleChange.abs() <= 22.5) {
        instruction = "Continue straight towards $nextDestination";
      } else if (angleChange.abs() <= 67.5) {
        instruction = angleChange > 0 
          ? "Take a slight right towards $nextDestination"
          : "Take a slight left towards $nextDestination";
      } else if (angleChange.abs() <= 112.5) {
        instruction = angleChange > 0
          ? "Turn right towards $nextDestination"
          : "Turn left towards $nextDestination";
      } else {
        instruction = angleChange > 0
          ? "Take a sharp right towards $nextDestination"
          : "Take a sharp left towards $nextDestination";
      }
    } else {
      instruction = "Continue towards $nextDestination";
    }

    if (objectName != null) {
      instruction = "You are approaching $objectName. $instruction";
      confirmationText = "Can you see the $objectName?";
    }

    return TurnInstruction(
      instruction: instruction,
      confirmationText: confirmationText,
      imagePath: getVertexImage(objectName ?? vertexId),
      cx: cx,
      cy: cy,
    );
  }

  static double _calculateAngleChange({
    required double? prevCx,
    required double? prevCy,
    required double currentX,
    required double currentY,
    required double nextX,
    required double nextY,
  }) {
    if (prevCx == null || prevCy == null) return 0;

    double prevAngle = _calculateAngleToPoint(
      currentX - prevCx,
      currentY - prevCy
    );
    
    double nextAngle = _calculateAngleToPoint(
      nextX - currentX,
      nextY - currentY
    );

    double angleDiff = nextAngle - prevAngle;
    
    if (angleDiff > 180) {
      angleDiff -= 360;
    } else if (angleDiff < -180) {
      angleDiff += 360;
    }

    return angleDiff;
  }

  static String _getInitialDirectionInstruction(
    double dx, 
    double dy, 
    String nextDestination
  ) {
    double angle = (_calculateAngleToPoint(dx, dy) + 180) % 360;
    return _getDirectionFromAngle(angle, nextDestination);
  }

  static double _calculateAngleToPoint(double dx, double dy) {
    double angleRadians = math.atan2(dx, -dy);
    double angleDegrees = (angleRadians * 180 / math.pi) % 360;
    return angleDegrees < 0 ? angleDegrees + 360 : angleDegrees;
  }

  static String _getDirectionFromAngle(double angle, String destination) {
    if (angle >= 337.5 || angle < 22.5) {
      return "Go straight ahead towards $destination";
    } else if (angle >= 22.5 && angle < 67.5) {
      return "Take a slight right towards $destination";
    } else if (angle >= 67.5 && angle < 112.5) {
      return "Turn right towards $destination";
    } else if (angle >= 112.5 && angle < 157.5) {
      return "Take a sharp right towards $destination";
    } else if (angle >= 157.5 && angle < 202.5) {
      return "Turn around towards $destination";
    } else if (angle >= 202.5 && angle < 247.5) {
      return "Take a sharp left towards $destination";
    } else if (angle >= 247.5 && angle < 292.5) {
      return "Turn left towards $destination";
    } else {
      return "Take a slight left towards $destination";
    }
  }

  static String getVertexImage(String vertexId) {
    switch (vertexId) {
      case 'v1':
        return 'assets/vertices/v1_platform1_west.jpg';
      case 'v2':
        return 'assets/vertices/v2_entry.jpg';
      case 'v3':
        return 'assets/vertices/v3_restroom1.jpg';
      case 'v4':
        return 'assets/vertices/v4_cafe1.jpg';
      case 'v5':
        return 'assets/vertices/v5_ticketcounter1.jpg';
      case 'v6':
        return 'assets/vertices/v6_waitingroom1.jpg';
      case 'v7':
        return 'assets/vertices/v7_infodesk1.jpg';
      case 'v8':
        return 'assets/vertices/v8_exit.jpg';
      case 'v9':
        return 'assets/vertices/v9_platform1_east.jpg';

      case 'v10':
      case 'v25':
        return 'assets/vertices/flyovers/v10_v25_flyover_down_east.jpg';
      case 'v11':
      case 'v26':
        return 'assets/vertices/flyovers/v11_v26_flyover_up_east.jpg';
      case 'v12':
      case 'v14':
        return 'assets/vertices/flyovers/v12_v14_flyover_down_west.jpg';
      case 'v13':
      case 'v15':
        return 'assets/vertices/flyovers/v13_v15_flyover_up_west.jpg';

      case 'v16':
      case 'v17':
        return 'assets/vertices/platform2_west.jpg';
      case 'v18':
      case 'v19':
        return 'assets/vertices/v19_restroom2.jpg';
      case 'v20':
        return 'assets/vertices/v20_cafe2.jpg';
      case 'v21':
        return 'assets/vertices/v21_ticketcounter2.jpg';
      case 'v22':
        return 'assets/vertices/v22_foodcourt2.jpg';
      case 'v23':
      case 'v24':
        return 'assets/vertices/platform2_east.jpg';
      default:
        return 'assets/vertices/default1.jpg';
    }
  }

  static bool _isFlyoverVertex(String vertexId) {
    List<String> flyoverVertices = [
      'v10',
      'v11',
      'v12',
      'v13',
      'v14',
      'v15',
      'v25',
      'v26'
    ];
    return flyoverVertices.contains(vertexId);
  }
}
