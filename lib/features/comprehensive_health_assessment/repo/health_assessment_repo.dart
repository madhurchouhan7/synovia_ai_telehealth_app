import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:synovia_ai_telehealth_app/features/comprehensive_health_assessment/data/user_health_model.dart';

class HealthAssessmentRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveHeathProfile(String uid, UserHealthModel userHealthModel) async{
    await _firestore.collection('users').doc(uid).set(
      {
        'healthProfile': userHealthModel.toMap(),
        
      },
      SetOptions(merge: true),
    );
  }

  Future<UserHealthModel?> getHealthProfile(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if (data.containsKey('healthProfile')) {
          return UserHealthModel.fromJson(data['healthProfile']);
        }
      }
    } catch (e) {
      print('Error fetching health profile: $e');
    }
    return null;
  } 
}
