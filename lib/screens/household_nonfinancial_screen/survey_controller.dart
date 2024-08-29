import 'dart:convert';
import 'package:get/get.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get_storage/get_storage.dart';

class SurveyController extends GetxController {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;
  final box = GetStorage();
  var questions = <Map<String, dynamic>>[].obs;
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
      questions.value = List<Map<String, dynamic>>.from(
          jsonDecode(cachedQuestions)['questions']);
      print('loaded cached questions:${questions.value}');
    }
  }

  Future<String> questionData() async {
    return await _remoteConfig.getString('questions');
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

      // Future<String> questionsData = await _remoteConfig.getString('questions');

      String questionsData = await questionData();

      print('Raw questions data from Remote Config: $questionsData');

      if (questionsData.isNotEmpty) {
        questions.value = List<Map<String, dynamic>>.from(
            jsonDecode(questionsData)['questions']);
        print('Parsed questions: ${questions.value}');

        //cache questions
        box.write('cached_questions', questionsData);
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
