import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:survey/models/dashboard_data_model.dart';


Future<DashboardDataModel> getDashboardData(Map<String, double> incomingData) async {
  try {
    var response = await http.post(
      Uri.parse('http://calcscorecard.pythonanywhere.com/process_data'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(incomingData),
    );
    if (response.statusCode == 200) {
      String sanitizedResponse = response.body.replaceAll('NaN', 'null');
      Map<String, dynamic> decodedJson = jsonDecode(sanitizedResponse)[0];

      DashboardDataModel data = DashboardDataModel.fromJson(decodedJson);
      return data;
    }
    else {
      String errorMessage = _getErrorMessage(response.body);
      print('Error is......: $errorMessage');
      throw Exception('Error ${response.statusCode}:\n$errorMessage');
    }
  } catch (e) {
    print('Caught Error: $e');
    rethrow;
  }
}

String _getErrorMessage(String responseBody) {
  try {
    final Map<String, dynamic> errorJson = jsonDecode(responseBody);
    print("error json in method");
    print(errorJson);
    return errorJson['error'] ?? 'Unknown error';
  } catch (e) {
    return 'Invalid error response: $responseBody';
  }
}