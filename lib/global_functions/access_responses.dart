class AccessResponses {
  static final AccessResponses _instance = AccessResponses._internal();

  factory AccessResponses() {
    return _instance;
  }
  AccessResponses._internal();

  List<Map<String, double>> allAnswers = []; // Store all responses


  List<double> getAllValues() {
    List<double> values = [];

    // Iterate through all answers and extract all values
    for (var answer in allAnswers) {
      values.addAll(answer.values.cast<double>());
    }

    print('Extracted values:');
    print(values);

    return values;
  }


}


