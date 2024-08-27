import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:survey/screens/household_nonfinancial_screen/survey_controller.dart';
import 'package:survey/screens/bussiness_nonfinancial/business_financial_screen.dart';

class SurveyScreen extends StatelessWidget {
  final String userId;

  SurveyScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final SurveyController surveyController = Get.put(SurveyController());
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    // Declare answerControllers outside of Obx
    List<TextEditingController> answerControllers = [];

    return Scaffold(
      appBar: AppBar(
        title: Text('Survey'), // Display the current survey page
      ),
      body: Obx(() {
        if (surveyController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (surveyController.questions.isEmpty) {
          return const Center(child: Text('No survey questions available.'));
        }

        // Initialize answerControllers only if not already initialized
        if (answerControllers.isEmpty) {
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
              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Question ${index + 1}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        surveyController.questions[index],
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: answerControllers[index],
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
                // Reference to the user's document
                final userDocRef =
                    FirebaseFirestore.instance.collection('users').doc(userId);

                // Save each answer to Firestore
                for (int i = 0; i < surveyController.questions.length; i++) {
                  String question = surveyController.questions[i];
                  String answer = answerControllers[i].text;

                  // Ensure answer is not empty before saving
                  if (answer.isNotEmpty) {
                    await userDocRef.collection('survey_responses').add({
                      'question': question,
                      'answer': answer,
                      'timestamp': FieldValue.serverTimestamp(),
                    });
                  }
                }

                Get.snackbar('Success', 'Survey responses saved successfully');

                // Navigate to the next survey page
                Get.to(() => BusinessFinancialScreen(
                      userId: userId,
                    ));
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
