import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:survey/controller/allPage_controller.dart';
import 'package:survey/global_functions/checkConnectivity.dart';
import 'package:survey/cache/users_response.dart';
import 'package:survey/screens/household_nonfinancial/household_screen.dart';

class BusinessNonfinancialSettwo extends StatefulWidget {
  final String userId;

  BusinessNonfinancialSettwo({super.key, required this.userId});

  @override
  _BusinessNonfinancialSettwoState createState() =>
      _BusinessNonfinancialSettwoState();
}

class _BusinessNonfinancialSettwoState
    extends State<BusinessNonfinancialSettwo> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<TextEditingController> answerControllers = [];
  bool _isSaved = false; // Flag to track if data has been saved
  @override
  void initState() {
    super.initState();

    final SurveyController surveyController = Get.put(SurveyController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      surveyController
          .checkStatusAndFetchQuestions('business_nonfinancial_settwo_key');
    });
  }

  @override
  Widget build(BuildContext context) {
    final SurveyController surveyController = Get.find<SurveyController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Business NonFinancial Details',
          style: TextStyle(fontSize: 15),
        ),
      ),
      body: Obx(() {
        if (surveyController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (surveyController.questions.isEmpty) {
          return const Center(child: Text('No survey questions available.'));
        }

        // Update: Ensure answerControllers are regenerated if the questions length changes
        if (answerControllers.length != surveyController.questions.length) {
          answerControllers = List.generate(
            surveyController.questions.length,
            (index) => TextEditingController(),
          );
        }

        return Form(
          key: _formKey,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: surveyController.questions.length,
            itemBuilder: (context, index) {
              var question = surveyController.questions[index];
              TextInputType keyboardType;

              // Determine keyboard type based on question data
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
                          fontWeight: FontWeight.bold,
                        ),
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
              if (_isSaved) {
                Get.snackbar('Info', 'Data has already been saved.');
                return;
              }

              bool isConnected = await isConnectedToInternet();

              List<Map<String, dynamic>> responses = [];
              for (int i = 0; i < surveyController.questions.length; i++) {
                var question = surveyController.questions[i];
                String answer = answerControllers[i].text;

                if (answer.isNotEmpty) {
                  responses.add({
                    'question': question['text'],
                    'answer': answer,
                  });
                }
              }

              if (isConnected) {
                try {
                  final userDocRef = FirebaseFirestore.instance
                      .collection('users')
                      .doc(widget.userId);

                  for (var response in responses) {
                    await userDocRef.collection('survey_responses').add({
                      'question': response['question'],
                      'answer': response['answer'],
                      'timestamp': FieldValue.serverTimestamp(),
                    });
                  }

                  setState(() {
                    _isSaved =
                        true; // Update flag to indicate data has been saved
                  });

                  Get.snackbar(
                      'Success', 'Survey responses saved successfully');
                } catch (e) {
                  Get.snackbar('Error', 'Failed to save responses. Try again.');
                }
              } else {
                // Save responses in cache if offline
                UserCacheService().saveSurveyResponse(widget.userId, responses);
                setState(() {
                  _isSaved =
                      true; // Update flag to indicate data has been saved
                });
                Get.snackbar('Saved Locally',
                    'No internet connection. Responses saved locally and will sync later.');
              }

              // Navigate to the next screen or show a success message
              // Get.to(SomeOtherScreen(userId: widget.userId));
              Get.to(() => HouseholdScreen(userId: widget.userId));
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
