import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:random_string/random_string.dart';
import 'package:survey/db_services/save_user.dart';
import 'package:survey/screens/business_financial/business_financial_screen.dart';
import '../global_functions//checkConnectivity.dart';
import 'package:survey/widgets/common_widgets.dart';
import 'package:survey/cache/users_response.dart';

class DetailScreen extends StatelessWidget {
  DetailScreen({super.key});

  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final DatabaseService _databaseService = DatabaseService();
  final UserCacheService _userCacheService = UserCacheService();
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
                const Icon(Icons.person_outline,
                    size: 100, color: Colors.blueAccent),
                const SizedBox(height: 20),
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
                          _userCacheService.clearUserData();
                        } else {
                          // save locally if offline
                          // await box
                          //     .write('cached_user', {'name': name, 'id': id});
                          // print('user cached locally');
                          _userCacheService.saveUserData(name, id);
                        }
                      } catch (e) {
                        print('Error saving user: $e');
                      }

                      Get.to(() => BusinessFinancialScreen(userId: id));
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
