import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> getDocByFieldId(String fieldId) async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: fieldId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      querySnapshot.docs.forEach((document) {
        Map<String, dynamic> currentUserData = document.data() as Map<String, dynamic>;

        print('this is the current User Data');
        print(currentUserData);
        print('Document ID: ${document.id}');
        print('Current User ID : ${fieldId}');
        print('User Name: ${currentUserData['name']}');
        print('Timestamp: ${currentUserData['timestamp']}');
        print(document.runtimeType);
      });
    } else {
      print('No document found with id: $fieldId');
    }
  } catch (e) {
    print('Error fetching document by field id: $e');
  }
}


Future<void> getSurveyResponses(String userId) async {
  try {
    // Reference to the user's document
    final userDocRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId);

    // Fetch all documents from the 'survey_responses' sub-collection
    QuerySnapshot querySnapshot = await userDocRef.collection('survey_responses').get();

    // Check if there are any responses
    if (querySnapshot.docs.isNotEmpty) {
      print('Survey responses:');
      // Loop through each response document
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        print('Response ID: ${doc.id}');
        print('Question: ${data['question']}');
        print('Answer: ${data['answer']}');
        print('Timestamp: ${data['timestamp']}');
      }
    } else {
      print('No survey responses found for user with ID: $userId');
    }
  } catch (e) {
    print('Error fetching survey responses: $e');
  }
}
