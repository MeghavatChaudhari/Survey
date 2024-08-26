import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:survey/screens/survey_screen.dart';

class EmailController extends GetxController {
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void validateAndProceed() {
    if (formKey.currentState!.validate()) {
      Get.to(() => SurveyScreen());
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
