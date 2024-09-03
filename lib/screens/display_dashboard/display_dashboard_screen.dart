import 'package:flutter/material.dart';
import 'package:survey/screens/display_dashboard/widgets/gauge_chart.dart';
import 'package:survey/screens/display_dashboard/widgets/info_table.dart';
import 'package:survey/screens/display_dashboard/widgets/table_item.dart';

class DisplayDashboardScreen extends StatelessWidget {
  const DisplayDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 40,),
          //const GaugeChart(),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: InfoTable(title: "Income Statement Component Wise Scores",
              tableItems:  [
                buildTableRow(
                    title: 'Income Statement Validation Score',
                    value: 'Extremely High'),
                buildTableRow(
                    title: 'Purchases/CoGs Validation Score',
                    value: 'Very High'),
                buildTableRow(
                    title: 'Business Cost Validation Score',
                    value: 'Extremely High'),
                buildTableRow(
                    title: 'Personal Cost Validation Score',
                    value: 'Extremely High'),
              ],
            ),
          ),
          const SizedBox(height: 20,),
          InfoTable(title: "Income Statement Element Wise Scores",
            tableItems:  [
              buildTableRow(
                  title: 'Sales Stock Validation Score',
                  value: 'Extremely High'),
              buildTableRow(
                  title: 'Employee Expense Validation Score',
                  value: 'Very High'),
              buildTableRow(
                  title: 'Household Food Cost Validation Score',
                  value: 'Extremely High'),
              buildTableRow(
                  title: 'Education Cost Validation Score',
                  value: 'Extremely High'),
            ],
          ),
          SizedBox(height: 30,),
          GaugeChart(),

        ],
      ),
    );
  }
}

