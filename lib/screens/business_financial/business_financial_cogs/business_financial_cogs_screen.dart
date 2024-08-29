import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:survey/screens/business_financial/business_financial_cogs/business_financial_cogs_controller.dart';
import 'package:survey/screens/business_financial/business_financial_operatingcost/business_financial_operatingcost_screen.dart';

class BusinessFinancialCogsScreen extends StatelessWidget {
  final String userId;
  bool flag = true;

  BusinessFinancialCogsScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final BusinessFinancialCogsController surveyController =
        Get.put(BusinessFinancialCogsController());
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    List<TextEditingController> answerControllers = [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Purchases cost of goods sold',
            style: TextStyle(fontSize: 15)),
      ),
      body: Obx(() {
        if (surveyController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (surveyController.business_survey_questions_cogs.isEmpty) {
          return const Center(child: Text('No survey questions available.'));
        }

        if (answerControllers.isEmpty) {
          answerControllers = List.generate(
            surveyController.business_survey_questions_cogs.length,
            (index) => TextEditingController(),
          );
        }

        return Form(
          key: _formKey,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: surveyController.business_survey_questions_cogs.length,
            itemBuilder: (context, index) {
              var question =
                  surveyController.business_survey_questions_cogs[index];
              TextInputType keyboardType;

              switch (question['keyboardType']) {
                case 'number':
                  keyboardType = TextInputType.number;
                  break;
                case 'boolean':
                  keyboardType = TextInputType.text;
                  break;
                default:
                  keyboardType = TextInputType.text;
              }

              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        question['text'],
                        style: const TextStyle(
                            fontSize: 21,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: answerControllers[index],
                        keyboardType: keyboardType,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Your answer',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an answer';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState?.validate() ?? false) {
              try {
                final userDocRef =
                    FirebaseFirestore.instance.collection('users').doc(userId);

                if (flag) {
                  for (int i = 0;
                      i <
                          surveyController
                              .business_survey_questions_cogs.length;
                      i++) {
                    var question =
                        surveyController.business_survey_questions_cogs[i];
                    String answer = answerControllers[i].text;

                    if (answer.isNotEmpty) {
                      await userDocRef.collection('survey_responses').add({
                        'question': question['text'],
                        'answer': answer,
                        'timestamp': FieldValue.serverTimestamp(),
                      });
                    }
                  }
                  flag = false;
                }

                Get.snackbar('Success', 'Survey responses saved successfully');

                Get.to(
                    () => BusinessFinancialOperatingcostScreen(userId: userId));
              } catch (e) {
                Get.snackbar('Error', 'Failed to save responses. Try again.');
              }
            } else {
              Get.snackbar('Error', 'Please answer all questions.');
            }
          },
          child: const Text('Next'),
        ),
      ),
    );
  }
}
