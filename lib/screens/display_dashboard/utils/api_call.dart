import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:survey/global_functions/access_responses.dart';
import 'package:survey/models/dashboard_data_model.dart';

Future<DashboardDataModel> getDashboardData() async {
  AccessResponses accessResponses = AccessResponses();
  try {
    var response = await http.post(
      Uri.parse('http://calcscorecard.pythonanywhere.com/process_data'),
      headers: {
        'Content-Type': 'application/json',
      },

      body: jsonEncode({
        // First Page
        "Monthly_Sales": accessResponses.getAllValues()[0], // First value
        "Weekly_Sales": accessResponses.getAllValues()[1],  // Second value
        "Daily_Sales": accessResponses.getAllValues()[2],   // Third value
        "Peak_Sales": accessResponses.getAllValues()[3],    // Fourth value
        "Peak_Duration": accessResponses.getAllValues()[4],  // Fifth value
        "Off_Sales": accessResponses.getAllValues()[5],      // Sixth value
        "Off_Duration": accessResponses.getAllValues()[6],   // Seventh value
        "Annual_Sales_1": accessResponses.getAllValues()[7],  // Eighth value


        //Second Page
        "Total_Purchase": accessResponses.getAllValues()[8],  // Ninth value
        "Monthly_Purchase": accessResponses.getAllValues()[9], // Tenth value
        "Weekly_Purchase": accessResponses.getAllValues()[10], // Eleventh value
        "Daily_Purchase": accessResponses.getAllValues()[11],  // Twelfth value
        "Irregular_Purchase": accessResponses.getAllValues()[12], // Thirteenth value
        "Monthly_Gross_Profit": accessResponses.getAllValues()[13], // Fourteenth value
        "Monthly_Gross_Margin": accessResponses.getAllValues()[14], // Fifteenth value

        //Third Page
        "Monthly_operating_Costs": accessResponses.getAllValues()[15], // Sixteenth value
        "Shop_Rental_Cost": accessResponses.getAllValues()[16], // Seventeenth value
        "Shop_Electric_Cost": accessResponses.getAllValues()[17], // Eighteenth value
        "Shop_Employee_Cost": accessResponses.getAllValues()[18], // Nineteenth value
        "Shop_Transport_Cost": accessResponses.getAllValues()[19], // Twentieth value
        "Shop_Other_Cost": accessResponses.getAllValues()[20], // Twenty-first value
        "Take_Home_Income": accessResponses.getAllValues()[21], // Twenty-second value

        //Fourth Page
        "Household_Cost": accessResponses.getAllValues()[22], // Twenty-third value
        "Household_Food_Cost": accessResponses.getAllValues()[23], // Twenty-fourth value
        "Household_Education_Cost": accessResponses.getAllValues()[24], // Twenty-fifth value
        "Household_Rental_Cost": accessResponses.getAllValues()[25], // Twenty-sixth value
        "Household_Utility_Cost": accessResponses.getAllValues()[26], // Twenty-seventh value
        "Household_Medical_Cost": accessResponses.getAllValues()[27], // Twenty-eighth value
        "Household_Transport_Cost": accessResponses.getAllValues()[28], // Twenty-ninth value
        "Household_Other_Cost": accessResponses.getAllValues()[29], // Thirtieth value
        "Household_Savings": accessResponses.getAllValues()[30], // Thirty-first value

        //Fifth Page
        "Fulltime_Employee": accessResponses.getAllValues()[31], // Thirty-ninth value
        "Parttime_Employee": accessResponses.getAllValues()[32], // Fortieth value
        "Inventory_Shop": accessResponses.getAllValues()[33], // Thirty-second value
        "Inventory_Warehouse": accessResponses.getAllValues()[34], // Thirty-third value
        "Total_Inventory": accessResponses.getAllValues()[35], // Thirty-fourth value
        "Daily_Customer_Count": accessResponses.getAllValues()[36], // Thirty-fifth value

        //Last Page
        "Household_Size": accessResponses.getAllValues()[37], // Thirty-sixth value
        "Childern_Education": accessResponses.getAllValues()[38], // Thirty-seventh value
        "Adult_Education": accessResponses.getAllValues()[39], // Thirty-eighth value

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


// Future<DashboardDataModel> getDashboardData() async {
//   AccessResponses accessResponses = AccessResponses();
//   try {
//     // Ensure that you handle indexes based on the expected values
//     var monthlySalesIndex = 0;  // Adjust this index based on your requirements
//     var weeklySalesIndex = 1;    // Adjust these indexes according to your data structure
//     var dailySalesIndex = 2;
//     var peakSalesIndex = 3;
//     var peakDurationIndex = 4;
//     var offSalesIndex = 5;
//     var offDurationIndex = 6;
//     var annualSales1Index = 7;
//     var totalPurchaseIndex = 8;
//     var monthlyPurchaseIndex = 9;
//     var weeklyPurchaseIndex = 10;
//     var dailyPurchaseIndex = 11;
//     var irregularPurchaseIndex = 12;
//     var monthlyGrossProfitIndex = 13;
//     var monthlyGrossMarginIndex = 14;
//     var monthlyOperatingCostsIndex = 15;
//     var shopRentalCostIndex = 16;
//     var shopElectricCostIndex = 17;
//     var shopEmployeeCostIndex = 18;
//     var shopTransportCostIndex = 19;
//     var shopOtherCostIndex = 20;
//     var takeHomeIncomeIndex = 21;
//     var householdCostIndex = 22;
//     var householdFoodCostIndex = 23;
//     var householdEducationCostIndex = 24;
//     var householdRentalCostIndex = 25;
//     var householdUtilityCostIndex = 26;
//     var householdMedicalCostIndex = 27;
//     var householdTransportCostIndex = 28;
//     var householdOtherCostIndex = 29;
//     var householdSavingsIndex = 30;
//     var inventoryShopIndex = 31;
//     var inventoryWarehouseIndex = 32;
//     var totalInventoryIndex = 33;
//     var dailyCustomerCountIndex = 34;
//     var householdSizeIndex = 35;
//     var childrenEducationIndex = 36;
//     var adultEducationIndex = 37;
//     var fulltimeEmployeeIndex = 38;
//     var parttimeEmployeeIndex = 39;
//
//     // Create the payload using dynamic indexes
//     var response = await http.post(
//       Uri.parse('http://calcscorecard.pythonanywhere.com/process_data'),
//       headers: {
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode({
//         "Monthly_Sales": accessResponses.getValuesAtIndex(monthlySalesIndex).isNotEmpty ? accessResponses.getValuesAtIndex(monthlySalesIndex).first : 0,
//         "Weekly_Sales": accessResponses.getValuesAtIndex(weeklySalesIndex).isNotEmpty ? accessResponses.getValuesAtIndex(weeklySalesIndex).first : 0,
//         "Daily_Sales": accessResponses.getValuesAtIndex(dailySalesIndex).isNotEmpty ? accessResponses.getValuesAtIndex(dailySalesIndex).first : 0,
//         "Peak_Sales": accessResponses.getValuesAtIndex(peakSalesIndex).isNotEmpty ? accessResponses.getValuesAtIndex(peakSalesIndex).first : 0,
//         "Peak_Duration": accessResponses.getValuesAtIndex(peakDurationIndex).isNotEmpty ? accessResponses.getValuesAtIndex(peakDurationIndex).first : 0,
//         "Off_Sales": accessResponses.getValuesAtIndex(offSalesIndex).isNotEmpty ? accessResponses.getValuesAtIndex(offSalesIndex).first : 0,
//         "Off_Duration": accessResponses.getValuesAtIndex(offDurationIndex).isNotEmpty ? accessResponses.getValuesAtIndex(offDurationIndex).first : 0,
//         "Annual_Sales_1": accessResponses.getValuesAtIndex(annualSales1Index).isNotEmpty ? accessResponses.getValuesAtIndex(annualSales1Index).first : 0,
//         "Total_Purchase": accessResponses.getValuesAtIndex(totalPurchaseIndex).isNotEmpty ? accessResponses.getValuesAtIndex(totalPurchaseIndex).first : 0,
//         "Monthly_Purchase": accessResponses.getValuesAtIndex(monthlyPurchaseIndex).isNotEmpty ? accessResponses.getValuesAtIndex(monthlyPurchaseIndex).first : 0,
//         "Weekly_Purchase": accessResponses.getValuesAtIndex(weeklyPurchaseIndex).isNotEmpty ? accessResponses.getValuesAtIndex(weeklyPurchaseIndex).first : 0,
//         "Daily_Purchase": accessResponses.getValuesAtIndex(dailyPurchaseIndex).isNotEmpty ? accessResponses.getValuesAtIndex(dailyPurchaseIndex).first : 0,
//         "Irregular_Purchase": accessResponses.getValuesAtIndex(irregularPurchaseIndex).isNotEmpty ? accessResponses.getValuesAtIndex(irregularPurchaseIndex).first : 0,
//         "Monthly_Gross_Profit": accessResponses.getValuesAtIndex(monthlyGrossProfitIndex).isNotEmpty ? accessResponses.getValuesAtIndex(monthlyGrossProfitIndex).first : 0,
//         "Monthly_Gross_Margin": accessResponses.getValuesAtIndex(monthlyGrossMarginIndex).isNotEmpty ? accessResponses.getValuesAtIndex(monthlyGrossMarginIndex).first : 0,
//         "Monthly_operating_Costs": accessResponses.getValuesAtIndex(monthlyOperatingCostsIndex).isNotEmpty ? accessResponses.getValuesAtIndex(monthlyOperatingCostsIndex).first : 0,
//         "Shop_Rental_Cost": accessResponses.getValuesAtIndex(shopRentalCostIndex).isNotEmpty ? accessResponses.getValuesAtIndex(shopRentalCostIndex).first : 0,
//         "Shop_Electric_Cost": accessResponses.getValuesAtIndex(shopElectricCostIndex).isNotEmpty ? accessResponses.getValuesAtIndex(shopElectricCostIndex).first : 0,
//         "Shop_Employee_Cost": accessResponses.getValuesAtIndex(shopEmployeeCostIndex).isNotEmpty ? accessResponses.getValuesAtIndex(shopEmployeeCostIndex).first : 0,
//         "Shop_Transport_Cost": accessResponses.getValuesAtIndex(shopTransportCostIndex).isNotEmpty ? accessResponses.getValuesAtIndex(shopTransportCostIndex).first : 0,
//         "Shop_Other_Cost": accessResponses.getValuesAtIndex(shopOtherCostIndex).isNotEmpty ? accessResponses.getValuesAtIndex(shopOtherCostIndex).first : 0,
//         "Take_Home_Income": accessResponses.getValuesAtIndex(takeHomeIncomeIndex).isNotEmpty ? accessResponses.getValuesAtIndex(takeHomeIncomeIndex).first : 0,
//         "Household_Cost": accessResponses.getValuesAtIndex(householdCostIndex).isNotEmpty ? accessResponses.getValuesAtIndex(householdCostIndex).first : 0,
//         "Household_Food_Cost": accessResponses.getValuesAtIndex(householdFoodCostIndex).isNotEmpty ? accessResponses.getValuesAtIndex(householdFoodCostIndex).first : 0,
//         "Household_Education_Cost": accessResponses.getValuesAtIndex(householdEducationCostIndex).isNotEmpty ? accessResponses.getValuesAtIndex(householdEducationCostIndex).first : 0,
//         "Household_Rental_Cost": accessResponses.getValuesAtIndex(householdRentalCostIndex).isNotEmpty ? accessResponses.getValuesAtIndex(householdRentalCostIndex).first : 0,
//         "Household_Utility_Cost": accessResponses.getValuesAtIndex(householdUtilityCostIndex).isNotEmpty ? accessResponses.getValuesAtIndex(householdUtilityCostIndex).first : 0,
//         "Household_Medical_Cost": accessResponses.getValuesAtIndex(householdMedicalCostIndex).isNotEmpty ? accessResponses.getValuesAtIndex(householdMedicalCostIndex).first : 0,
//         "Household_Transport_Cost": accessResponses.getValuesAtIndex(householdTransportCostIndex).isNotEmpty ? accessResponses.getValuesAtIndex(householdTransportCostIndex).first : 0,
//         "Household_Other_Cost": accessResponses.getValuesAtIndex(householdOtherCostIndex).isNotEmpty ? accessResponses.getValuesAtIndex(householdOtherCostIndex).first : 0,
//         "Household_Savings": accessResponses.getValuesAtIndex(householdSavingsIndex).isNotEmpty ? accessResponses.getValuesAtIndex(householdSavingsIndex).first : 0,
//         "Inventory_Shop": accessResponses.getValuesAtIndex(inventoryShopIndex).isNotEmpty ? accessResponses.getValuesAtIndex(inventoryShopIndex).first : 0,
//         "Inventory_Warehouse": accessResponses.getValuesAtIndex(inventoryWarehouseIndex).isNotEmpty ? accessResponses.getValuesAtIndex(inventoryWarehouseIndex).first : 0,
//         "Total_Inventory": accessResponses.getValuesAtIndex(totalInventoryIndex).isNotEmpty ? accessResponses.getValuesAtIndex(totalInventoryIndex).first : 0,
//         "Daily_Customer_Count": accessResponses.getValuesAtIndex(dailyCustomerCountIndex).isNotEmpty ? accessResponses.getValuesAtIndex(dailyCustomerCountIndex).first : 0,
//         "Household_Size": accessResponses.getValuesAtIndex(householdSizeIndex).isNotEmpty ? accessResponses.getValuesAtIndex(householdSizeIndex).first : 0,
//         "Childern_Education": accessResponses.getValuesAtIndex(childrenEducationIndex).isNotEmpty ? accessResponses.getValuesAtIndex(childrenEducationIndex).first : 0,
//         "Adult_Education": accessResponses.getValuesAtIndex(adultEducationIndex).isNotEmpty ? accessResponses.getValuesAtIndex(adultEducationIndex).first : 0,
//         "Fulltime_Employee": accessResponses.getValuesAtIndex(fulltimeEmployeeIndex).isNotEmpty ? accessResponses.getValuesAtIndex(fulltimeEmployeeIndex).first : 0,
//         "Parttime_Employee": accessResponses.getValuesAtIndex(parttimeEmployeeIndex).isNotEmpty ? accessResponses.getValuesAtIndex(parttimeEmployeeIndex).first : 0,
//       }),
//     );
//
//     if (response.statusCode == 200) {
//       // Handle your successful response
//       var dashboardData = DashboardDataModel.fromJson(json.decode(response.body));
//       return dashboardData;
//     } else {
//       // Handle your error response
//       throw Exception('Failed to load dashboard data');
//     }
//   } catch (e) {
//     // Handle any errors
//     print("Error occurred: $e");
//     throw Exception('Error fetching data');
//   }
// }
