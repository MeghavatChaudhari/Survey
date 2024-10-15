import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:survey/models/dashboard_data_model.dart';
import 'package:survey/screens/detail_screen.dart';
import 'package:survey/screens/display_dashboard/utils/api_call.dart';
import 'package:survey/screens/display_dashboard/utils/color_display.dart';
import 'package:survey/screens/display_dashboard/utils/get_current_user.dart';
import 'package:survey/screens/display_dashboard/widgets/field_gauge_chart.dart';
import 'package:survey/screens/display_dashboard/widgets/trust_score_gauge_chart.dart';
import 'package:survey/screens/display_dashboard/widgets/trust_component_table.dart';

class DisplayDashboardScreen extends StatefulWidget {
  final String userId;

  const DisplayDashboardScreen({super.key, required this.userId});

  @override
  State<DisplayDashboardScreen> createState() => _DisplayDashboardScreenState();
}

class _DisplayDashboardScreenState extends State<DisplayDashboardScreen> {

   Future<DashboardDataModel>? dashboardData;
   List<String> docIds = [];


   @override
  void initState() {
    super.initState();
    dashboardData = getDashboardData();
    getDocByFieldId(widget.userId);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          "TRUST SCORE ANALYSIS",
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: FutureBuilder<DashboardDataModel>(
        future: dashboardData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            DashboardDataModel data = snapshot.data!;
            return SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: TrustScoreGaugeChart(
                        gaugeValue: data.trustScore ?? 0.0,
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        // getResponses(widget.userId);
                        getSurveyResponses(widget.userId);

                      },
                      child: TrustComponentTable(
                        data: [
                          {
                            'component': 'Income (30%)',
                            'grade': data.incomeTrustGrade,
                            'color': gaugeDisplay(trustScoreString: data.incomeTrustGrade)
                          },
                          {
                            'component': 'Operating Cost (25%)',
                            'grade': data.incomeTrustGrade,
                            'color': gaugeDisplay(trustScoreString: data.incomeTrustGrade)
                          },
                          {
                            'component': 'Household Cost (30%)',
                            'grade': data.householdCostTrustGrade,
                            'color': gaugeDisplay(trustScoreString: data.householdCostTrustGrade)
                          },
                          {
                            'component': 'Average Ticket (10%)',
                            'grade': data.avTicketTrustGrade,
                            'color': gaugeDisplay(trustScoreString: data.avTicketTrustGrade)
                          },
                          {
                            'component': 'Household Food Cost (5%)',
                            'grade': data.foodCostTrustGrade,
                            'color': gaugeDisplay(trustScoreString: data.foodCostTrustGrade)
                          },
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FieldGaugeChart(
                          headerText: 'Shop Rental Cost',
                          annotationText: data.srGrade ?? 'nan',
                        ),
                        FieldGaugeChart(
                          headerText: 'Education Cost',
                          annotationText: data.eduGrade ?? 'nan',
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FieldGaugeChart(
                          headerText: 'House Rental Cost',
                          annotationText: data.hrGrade ?? 'nan',
                        ),
                        FieldGaugeChart(
                          headerText: 'Employee Cost',
                          annotationText: data.empGrade ?? 'nan',
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(child: Text('No data available.'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(child: Icon(Icons.home,color: Colors.blue[900],),
    onPressed: (){
      Get.to(() => DetailScreen());
    }
          ,),
    );
  }
}