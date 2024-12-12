class TrainCoachMapping {
  final String trainNumber;
  final int platformNumber;
  final Map<String, String> coachToAreaMap; // Maps coach numbers to platform areas

  TrainCoachMapping({
    required this.trainNumber,
    required this.platformNumber,
    required this.coachToAreaMap,
  });

  // Get platform area for a specific coach
  String? getCoachArea(String coachNumber) {
    return coachToAreaMap[coachNumber];
  }

  // Get vertex ID for a coach position
  String getVertexId(String coachNumber) {
    String area = coachToAreaMap[coachNumber] ?? "1";
    return "p${platformNumber}c$area";
  }
}

// Sample train data with randomized coach positions
final Map<String, TrainCoachMapping> trainMappings = {
  "12345": TrainCoachMapping(
    trainNumber: "12345",
    platformNumber: 1,
    coachToAreaMap: {
      "S1": "4",  // S1 is at area 4
      "S2": "5",  // S2 is at area 5
      "S3": "1",  // S3 is at area 1
      "S4": "2",  // S4 is at area 2
      "S5": "3",  // S5 is at area 3
      "A1": "3",  // AC coach at area 3
      "B1": "2",  // Sleeper coach at area 2
    },
  ),
  "67890": TrainCoachMapping(
    trainNumber: "67890",
    platformNumber: 2,
    coachToAreaMap: {
      "S1": "5",  // S1 is at the end
      "S2": "4",
      "S3": "3",
      "S4": "1",  // S4 is at the start
      "S5": "2",
      "A1": "4",
      "B1": "3",
    },
  ),
  "11223": TrainCoachMapping(
    trainNumber: "11223",
    platformNumber: 1,
    coachToAreaMap: {
      "S1": "2",
      "S2": "1",  // S2 is at the start
      "S3": "5",  // S3 is at the end
      "S4": "4",
      "S5": "3",
      "A1": "5",
      "A2": "4",
      "B1": "1",
    },
  ),
  "99887": TrainCoachMapping(
    trainNumber: "99887",
    platformNumber: 2,
    coachToAreaMap: {
      "S1": "3",
      "S2": "4",
      "S3": "2",
      "S4": "5",
      "S5": "1",  // S5 is at the start
      "A1": "1",
      "B1": "5",
    },
  ),
  "44556": TrainCoachMapping(
    trainNumber: "44556",
    platformNumber: 1,
    coachToAreaMap: {
      "S1": "5",
      "S2": "3",
      "S3": "4",
      "S4": "2",
      "S5": "1",
      "A1": "2",
      "A2": "3",
      "B1": "4",
      "B2": "5",
    },
  ),
};