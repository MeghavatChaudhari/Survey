import 'dart:convert';
import 'package:get/get.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get_storage/get_storage.dart';

class BusinessNonfinancialSetoneController extends GetxController {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;
  var business_survey_questions_setone = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    _remoteConfig.setDefaults({
      'questions': jsonEncode([
        {
          "id": 1,
          "text": "Default Question 1",
          "keyboardType": "text",
          "questionType": "short_answer"
        }
      ])
    });
    loadCachedQuestions();
    fetchSurveyQuestions();
  }

  void loadCachedQuestions() async {
    String? cachedQuestions = box.read('cached_questions');
    if (cachedQuestions != null) {
      business_survey_questions_setone.value =
          await List<Map<String, dynamic>>.from(
              jsonDecode(cachedQuestions)['questions']);
      print(
          'loaded cached questions:${business_survey_questions_setone.value}');
    }
  }

  Future<void> fetchSurveyQuestions() async {
    try {
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: Duration.zero,
        ),
      );

      await _remoteConfig.fetchAndActivate();

      String questionsData =
          _remoteConfig.getString('business_nonfinancial_setone_key');

      print('Raw questions data from Remote Config: $questionsData');

      if (questionsData.isNotEmpty) {
        var decodedData = jsonDecode(questionsData);
        if (decodedData['business_nonfinancial_setone_key'] != null) {
          business_survey_questions_setone.value =
              List<Map<String, dynamic>>.from(
                  decodedData['business_nonfinancial_setone_key']);
          print('Parsed questions: ${business_survey_questions_setone.value}');
        } else {
          print('No questions found in the fetched data.');
        }
      } else {
        print('questionsData is empty.');
      }
    } catch (e) {
      print('Error fetching survey questions: $e');
      Get.snackbar('Error', 'Failed to load the questions');
    } finally {
      isLoading.value = false;
    }
  }
}
