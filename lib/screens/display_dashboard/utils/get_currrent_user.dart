import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> getDocByFieldId(String fieldId) async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: fieldId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      querySnapshot.docs.forEach((document) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        print(document.data());
        print('Document ID: ${document.id}');
        print('Current User ID : ${fieldId}');
        print('User Name: ${data['name']}');
        print('Timestamp: ${data['timestamp']}');
      });
    } else {
      print('No document found with id: $fieldId');
    }
  } catch (e) {
    print('Error fetching document by field id: $e');
  }
}