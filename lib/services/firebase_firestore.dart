import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> saveUserData({
  required String name,
  required String age,
  required String dob,
  required String gender,
  required String height,
  required String weight,
  required String target_weight,
  required String weekly_goal,
}) async {
  User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': name,
        'phone': user.phoneNumber,
        'age': age,
        'dob': dob,
        'gender': gender,
        'height': height,
        'weight': weight,
        'target_weight': target_weight,
        'weekly_goal': weekly_goal,
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      print("Data saved successfully!");
    } catch (e) {
      print("Error saving data: $e");
    }
  } else {
    print("No user signed in, cannot save data.");
  }
}

Future<void> fetchUserData() async {
  User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (doc.exists) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      print("Name: ${data['name']}");
      print("Age: ${data['age']}");
      print("DOB: ${data['dob']}");
    } else {
      print("No profile found");
    }
  }
}