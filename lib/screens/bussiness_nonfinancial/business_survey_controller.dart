import 'package:get/get.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class BussinessSurveyController extends GetxController {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;
  var business_survey_questions = <String>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _remoteConfig
        .setDefaults({'questions': 'Default Question 1,Default Question 2'});
    fetchSurveyQuestions();
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
          _remoteConfig.getString('business_financial_questions');

      print('Raw questions data from Remote Config: $questionsData');

      if (questionsData.isNotEmpty) {
        business_survey_questions.value =
            List<String>.from(questionsData.split(','));
        print('Parsed questions: ${business_survey_questions.value}');
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
