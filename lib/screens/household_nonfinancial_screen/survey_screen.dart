import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';
import 'package:survey/screens/household_nonfinancial_screen/survey_controller.dart';
import 'package:survey/screens/business_financial/business_financial_screen.dart';

class SurveyScreen extends StatelessWidget {
  final String userId;
  bool flag = true;
  SurveyScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final SurveyController surveyController = Get.put(SurveyController());
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final box = GetStorage();
    List<TextEditingController> answerControllers = [];

    Map<String, dynamic>? cachedUser = box.read('cached_user');
    // if (cachedUser != null) {
    //   String cachedName = cachedUser['name'];
    //   String cachedId = cachedUser['id'];
    //   print('using cached data: Name=$cachedName , ID =$cachedId ');
    // }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Household Non Financial Details',
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
              var question = surveyController.questions[index];
              TextInputType keyboardType;

              switch (question['keyboardType']) {
                case 'number':
                  keyboardType = TextInputType.number;
                  break;
                case 'boolean':
                  // In a real-world scenario, you might want to use a Switch or Checkbox for boolean input.
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
                  for (int i = 0; i < surveyController.questions.length; i++) {
                    var question = surveyController.questions[i];
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

                Get.to(() => BusinessFinancialScreen(userId: userId));
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
