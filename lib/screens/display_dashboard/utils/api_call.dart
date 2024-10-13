import 'dart:convert'; // For JSON encoding and decoding
import 'package:http/http.dart' as http;
import 'package:survey/models/dashboard_data_model.dart'; // Import your model

Future<DashboardDataModel> getDashboardData() async {
  try {
    var response = await http.post(
      Uri.parse('http://calcscorecard.pythonanywhere.com/process_data'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "Household_Size": 2,
        "Childern_Education": 0,
        "Adult_Education": 0,
        "Fulltime_Employee": 0,
        "Parttime_Employee": 0,
        "Inventory_Shop": 60000,
        "Inventory_Warehouse": 30000,
        "Total_Inventory": 90000,
        "Daily_Customer_Count": 30,
        "Daily_Sales": 2300,
        "Weekly_Sales": 16100,
        "Monthly_Sales": 60000,
        "Peak_Sales": 5000,
        "Peak_Duration": 6,
        "Off_Sales": 1000,
        "Off_Duration": 4,
        "Annual_Sales_1": 1008000,
        "Total_Purchase": 15000,
        "Monthly_Purchase": 5000,
        "Weekly_Purchase": 1000,
        "Daily_Purchase": 4500,
        "Irregular_Purchase": 1000,
        "Monthly_Gross_Profit": 24000,
        "Monthly_Gross_Margin": 16,
        "Monthly_operating_Costs": 5000,
        "Shop_Rental_Cost": 0,
        "Shop_Electric_Cost": 100,
        "Shop_Employee_Cost": 0,
        "Shop_Transport_Cost": 250,
        "Shop_Other_Cost": 4650,
        "Take_Home_Income": 19000,
        "Household_Cost": 8000,
        "Household_Food_Cost": 3000,
        "Household_Education_Cost": 0,
        "Household_Rental_Cost": 2000,
        "Household_Utility_Cost": 500,
        "Household_Medical_Cost": 1000,
        "Household_Transport_Cost": 400,
        "Household_Other_Cost": 2000,
        "Household_Savings": 5000
      }),
    );

    if (response.statusCode == 200) {
      String sanitizedResponse = response.body.replaceAll('NaN', 'null');
      Map<String, dynamic> decodedJson = jsonDecode(sanitizedResponse)[0];

      DashboardDataModel data = DashboardDataModel.fromJson(decodedJson);
      print(data.runtimeType);
      return data;
    } else {
      print('Failed with status: ${response.statusCode}, ${response.body}');
      throw Exception('Failed to load dashboard data');
    }
  } catch (e) {
    print('Error occurred: $e');
    throw Exception('Error occurred while fetching data: $e');
  }
}
