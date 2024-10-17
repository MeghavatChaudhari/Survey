class AccessResponses {
  static final AccessResponses _instance = AccessResponses._internal();

  factory AccessResponses() {
    return _instance;
  }
  AccessResponses._internal();

  List<Map<String, double>> allAnswers = []; // Store all responses


  Map<String, double> getMapValues(List<Map<String, double>> answersList) {
    Map<String, double> mergedMap = {};
    for (var map in answersList) {
      mergedMap.addAll(map); // Add each map's key-value pairs to the merged map
    }
    print('Merged Map: $mergedMap');
    return mergedMap;
  }

}


