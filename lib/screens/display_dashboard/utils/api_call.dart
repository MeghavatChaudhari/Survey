import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:survey/custom_exceptions.dart';
import 'package:survey/global_functions/access_responses.dart';
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
      print(data.runtimeType);
      return data;
    }else if (response.statusCode == 404) {
      throw ServerException('Data not found (404)');
    } else if (response.statusCode == 500) {
      throw ServerException('Internal server error (500)');
    } else {
      throw UnknownException('Failed with status: ${response.statusCode}');
    }
  } catch (e) {
    if (e is SocketException) {
      throw NetworkException('No Internet connection');
    } else {
      throw UnknownException('Unexpected error: $e');
    }
  }
}
