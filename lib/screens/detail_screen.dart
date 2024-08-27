import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:survey/common_widgets/custom_widgets.dart';
import 'package:survey/screens/household_nonfinancial_screen/survey_screen.dart';
import 'package:survey/databse_services/save_user.dart';
import 'package:random_string/random_string.dart';

class DetailScreen extends StatelessWidget {
  DetailScreen({super.key});

  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final DatabaseService _databaseService = DatabaseService();

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
                Text(
                  'Personal Information',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Enter your details below',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 30),
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
                SizedBox(height: 20),
                CustomTextField(
                  label: 'Contact Number',
                  controller: _contactController,
                  icon: Icons.phone_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your contact number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 30),
                CustomButton(
                  label: "Submit",
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      String id = randomAlphaNumeric(10);

                      await _databaseService.addUser(
                        _nameController.text,
                        _contactController.text,
                        id,
                      );
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
