import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:synovia_ai_telehealth_app/features/comprehensive_health_assessment/data/user_health_model.dart';

class ChatbotService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserHealthModel?> getCurrentUserHealthData() async {
    final user = _auth.currentUser;
    if (user == null) {
      print('No user is currently signed in.');
      return null;
    }

    try {
      final docSnapshot =
          await _firestore
              .collection('user_health_assessments')
              .doc(user.uid)
              .get();

      if (docSnapshot.exists && docSnapshot.data() != null) {
        return UserHealthModel.fromJson(docSnapshot.data()!);
      } else {
        print('User health data not found for UID: ${user.uid}');
        return null;
      }
    } catch (e) {
      print('Error fetching user health data: $e');
      return null;
    }
  }
}
