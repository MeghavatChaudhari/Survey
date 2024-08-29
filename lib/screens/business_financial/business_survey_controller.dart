import 'dart:convert';
import 'package:get/get.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get_storage/get_storage.dart';

class BusinessSurveyController extends GetxController {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;
  var business_survey_questions = <Map<String, dynamic>>[].obs;
  final box = GetStorage();
  var isLoading = true.obs;

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

  void loadCachedQuestions() {
    String? cachedQuestions = box.read('cached_questions');
    if (cachedQuestions != null) {
      business_survey_questions.value = List<Map<String, dynamic>>.from(
          jsonDecode(cachedQuestions)['questions']);
      print('loaded cached questions:${business_survey_questions.value}');
    }
  }

  Future<String> questionData() async {
    return await _remoteConfig.getString('business_financial_questions');
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
      String questionsData = await questionData();

      // String questionsData =
      //     _remoteConfig.getString('business_financial_questions');

      print('Raw questions data from Remote Config: $questionsData');

      if (questionsData.isNotEmpty) {
        var decodedData = jsonDecode(questionsData);
        if (decodedData['business_financial_questions'] != null) {
          business_survey_questions.value = List<Map<String, dynamic>>.from(
              decodedData['business_financial_questions']);
          print('Parsed questions: ${business_survey_questions.value}');

          box.write('cached_questions', questionsData);
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
