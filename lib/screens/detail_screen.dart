import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:survey/common_widgets/custom_widgets.dart';
import 'package:survey/screens/household_nonfinancial_screen/survey_screen.dart';
import 'package:survey/databse_services/save_user.dart';
import 'package:random_string/random_string.dart';
import 'package:get_storage/get_storage.dart';

import '../utility/checkConnectivity.dart';

class DetailScreen extends StatelessWidget {
  DetailScreen({super.key});

  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final DatabaseService _databaseService = DatabaseService();
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person_outline, size: 100, color: Colors.blueAccent),
                SizedBox(height: 20),
                const SizedBox(height: 10),
                const Text(
                  'Enter your details below',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 30),
                CustomTextField(
                  label: 'Name',
                  controller: _nameController,
                  icon: Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                const SizedBox(height: 30),
                CustomButton(
                  label: "Next",
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      String id = randomAlphaNumeric(10);

                      String name = _nameController.text;
                      bool isconnected = await isConnectedToInternet();
                      print('Internet connection status: $isconnected');
                      try {
                        if (isconnected) {
                          //save to db if online
                          await _databaseService.addUser(name, id);
                          print('user saved to db');
                        } else {
                          // save locally if offline
                          await box
                              .write('cached_user', {'name': name, 'id': id});
                          print('user cached locally');
                        }
                      } catch (e) {
                        print('Error saving user: $e');
                      }

                      Get.to(() => SurveyScreen(userId: id));
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
