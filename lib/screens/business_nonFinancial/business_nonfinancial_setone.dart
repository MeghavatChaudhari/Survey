import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:survey/controller/allPage_controller.dart';
import 'package:survey/global_functions/access_responses.dart';
import 'package:survey/global_functions/checkConnectivity.dart';
import 'package:survey/cache/users_response.dart';
import 'package:survey/screens/business_nonFinancial/business_nonfinancial_settwo.dart';
import 'package:survey/screens/business_financial/business_financial_personalcost.dart';
import 'package:survey/screens/household_nonfinancial/household_screen.dart';

class BusinessNonfinancialSetone extends StatefulWidget {
  final String userId;

  BusinessNonfinancialSetone({super.key, required this.userId});

  @override
  _BusinessNonfinancialSetoneState createState() =>
      _BusinessNonfinancialSetoneState();
}

class _BusinessNonfinancialSetoneState
    extends State<BusinessNonfinancialSetone> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<TextEditingController> answerControllers = [];
  bool _isSaved = false;
  bool _isLoading = true;
  List<FocusNode> focusNodes = [];
  AccessResponses accessResponses = AccessResponses();
  Map<int, String?> dropdownValues = {};

  @override
  void initState() {
    super.initState();
    final SurveyController surveyController = Get.put(SurveyController());
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await surveyController
          .checkStatusAndFetchQuestions('business_nonfinancial_setone_key');
      await _loadSavedResponses();
      setState(() {
        _isLoading = false;
      });
    });

    surveyController.questions.listen((questions) {
      setState(() {
        focusNodes = List.generate(
          questions.length,
          (index) => FocusNode(),
        );
      });
    });
  }

  Future<void> _loadSavedResponses() async {
    final SurveyController surveyController = Get.find<SurveyController>();
    final userDocRef =
        FirebaseFirestore.instance.collection('users').doc(widget.userId);

    final snapshot = await userDocRef.collection('survey_responses').get();

    Map<String, String> savedAnswers = {};
    if (snapshot.docs.isNotEmpty) {
      for (var doc in snapshot.docs) {
        savedAnswers[doc['question']] = doc['answer'];
      }
    }

    if (answerControllers.isEmpty) {
      setState(() {
        answerControllers =
            List.generate(surveyController.questions.length, (index) {
          var question = surveyController.questions[index];
          var controller =
              TextEditingController(text: savedAnswers[question['text']] ?? '');

          controller.addListener(() {
            setState(() {
              _isSaved = false;
            });
          });

          return controller;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final SurveyController surveyController = Get.find<SurveyController>();

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Business NonFinancial Details'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Business NonFinancial Details',
          style: TextStyle(fontSize: 15),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            Get.to(() => BusinessFinancialPersonalcost(userId: widget.userId));
          },
        ),
      ),
      body: Obx(() {
        if (surveyController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (surveyController.questions.isEmpty) {
          return const Center(child: Text('No survey questions available.'));
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
                      question['keyboardType'] == "dropdown"
                          ? DropdownButtonFormField<String>(
                              value: dropdownValues[question['id']],
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Your answer',
                                prefixIcon: Icon(Icons.question_answer),
                              ),
                              hint: const Text("Select an option"),
                              items: (question['options'] as List<dynamic>)
                                  .map((dynamic value) => value.toString())
                                  .toList()
                                  .map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select an option';
                                }
                                return null;
                              },
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownValues[question['id']] = newValue;
                                });
                              },
                            )
                          : TextFormField(
                              controller: answerControllers[index],
                              keyboardType: keyboardType,
                              textInputAction:
                                  index == surveyController.questions.length - 1
                                      ? TextInputAction.done
                                      : TextInputAction.next,
                              focusNode: focusNodes[index],
                              onFieldSubmitted: (_) {
                                if (index <
                                    surveyController.questions.length - 1) {
                                  FocusScope.of(context)
                                      .requestFocus(focusNodes[index + 1]);
                                } else {
                                  FocusScope.of(context)
                                      .unfocus(); // Close the keyboard if it's the last field
                                }
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Your answer',
                                prefixIcon:
                                    question['keyboardType'] == "location"
                                        ? GestureDetector(
                                            onTap: () {
                                              //_getCurrentLocation(index);
                                            },
                                            child: Icon(Icons.location_on))
                                        : Icon(Icons.question_answer),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter an answer';
                                }
                                String label = question['label'];
                                if (label == "Total_Inventory") {
                                  double shopValue = double.tryParse(
                                          answerControllers
                                              .firstWhere(
                                                  (controller) =>
                                                      surveyController
                                                                  .questions[
                                                              answerControllers
                                                                  .indexOf(
                                                                      controller)]
                                                          ['label'] ==
                                                      "Inventory_Shop",
                                                  orElse: () =>
                                                      TextEditingController(
                                                          text: "0"))
                                              .text) ??
                                      0.0;

                                  double warehouseValue = double.tryParse(
                                          answerControllers
                                              .firstWhere(
                                                  (controller) =>
                                                      surveyController
                                                                  .questions[
                                                              answerControllers
                                                                  .indexOf(
                                                                      controller)]
                                                          ['label'] ==
                                                      "Inventory_Warehouse",
                                                  orElse: () =>
                                                      TextEditingController(
                                                          text: "0"))
                                              .text) ??
                                      0.0;

                                  double totalValue =
                                      double.tryParse(value) ?? 0.0;

                                  if (totalValue !=
                                      shopValue + warehouseValue) {
                                    return "Total must equal Shop and Warehouse values";
                                  }
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  _isSaved = false;
                                });
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
                  if(question['keyboardType'] != "dropdown"){
                    responses.add({
                      'question': question['text'],
                      'answer': answer,
                    });
                    accessResponses.checkAndInsertValues({
                      question['label']: double.parse(answer),
                    });
                  }
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
                    _isSaved = true;
                  });

                  Get.snackbar(
                      'Success', 'Survey responses saved successfully');
                } catch (e) {
                  Get.snackbar('Error', 'Failed to save responses. Try again.');
                }
              } else {
                UserCacheService().saveSurveyResponse(widget.userId, responses);
                setState(() {
                  _isSaved = true;
                });
                Get.snackbar('Saved Locally',
                    'No internet connection. Responses saved locally and will sync later.');
              }
              print('global');
              print(accessResponses.allAnswers);

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
