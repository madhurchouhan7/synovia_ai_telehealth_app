import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:synovia_ai_telehealth_app/features/symptoms_history/models/symptom_record.dart';

class SymptomsHistoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user ID
  String? get _userId => _auth.currentUser?.uid;

  // Save a new symptom record
  Future<void> saveSymptomRecord({
    required String symptoms,
    required String severity,
    required String aiAdvice,
    required String recommendedSpecialist,
  }) async {
    if (_userId == null) {
      throw Exception('User not authenticated');
    }

    final symptomRecord = SymptomRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      symptoms: symptoms,
      severity: severity,
      aiAdvice: aiAdvice,
      recommendedSpecialist: recommendedSpecialist,
      timestamp: DateTime.now(),
    );

    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('symptoms_history')
        .doc(symptomRecord.id)
        .set(symptomRecord.toFirestore());
  }

  // Get all symptom records for a user
  Future<List<SymptomRecord>> getSymptomHistory() async {
    if (_userId == null) {
      throw Exception('User not authenticated');
    }

    final querySnapshot =
        await _firestore
            .collection('users')
            .doc(_userId)
            .collection('symptoms_history')
            .orderBy('timestamp', descending: true)
            .get();

    return querySnapshot.docs
        .map((doc) => SymptomRecord.fromFirestore(doc))
        .toList();
  }

  // Get active symptoms (not resolved) - Filter in memory to avoid index requirement
  Future<List<SymptomRecord>> getActiveSymptoms() async {
    if (_userId == null) {
      throw Exception('User not authenticated');
    }

    final allSymptoms = await getSymptomHistory();
    return allSymptoms.where((symptom) => symptom.isActive).toList();
  }

  // Get symptoms by time period - Filter in memory to avoid index requirement
  Future<List<SymptomRecord>> getSymptomsByPeriod({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    if (_userId == null) {
      throw Exception('User not authenticated');
    }

    final allSymptoms = await getSymptomHistory();
    return allSymptoms.where((symptom) {
      return symptom.timestamp.isAfter(startDate) &&
          symptom.timestamp.isBefore(endDate.add(Duration(days: 1)));
    }).toList();
  }

  // Get symptoms from last week
  Future<List<SymptomRecord>> getLastWeekSymptoms() async {
    final now = DateTime.now();
    final lastWeek = now.subtract(const Duration(days: 7));
    return getSymptomsByPeriod(startDate: lastWeek, endDate: now);
  }

  // Get symptoms from last month
  Future<List<SymptomRecord>> getLastMonthSymptoms() async {
    final now = DateTime.now();
    final lastMonth = DateTime(now.year, now.month - 1, now.day);
    return getSymptomsByPeriod(startDate: lastMonth, endDate: now);
  }

  // Mark a symptom as resolved
  Future<void> markSymptomResolved(String symptomId) async {
    if (_userId == null) {
      throw Exception('User not authenticated');
    }

    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('symptoms_history')
        .doc(symptomId)
        .update({
          'isActive': false,
          'resolvedAt': Timestamp.fromDate(DateTime.now()),
        });
  }

  // Add follow-up notes to a symptom
  Future<void> addFollowUpNotes(String symptomId, String notes) async {
    if (_userId == null) {
      throw Exception('User not authenticated');
    }

    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('symptoms_history')
        .doc(symptomId)
        .update({'followUpNotes': notes});
  }

  // Get symptoms by severity - Filter in memory to avoid index requirement
  Future<List<SymptomRecord>> getSymptomsBySeverity(String severity) async {
    if (_userId == null) {
      throw Exception('User not authenticated');
    }

    final allSymptoms = await getSymptomHistory();
    return allSymptoms
        .where((symptom) => symptom.severity == severity)
        .toList();
  }

  // Get health insights based on symptoms history
  Future<Map<String, dynamic>> getHealthInsights() async {
    final allSymptoms = await getSymptomHistory();

    if (allSymptoms.isEmpty) {
      return {
        'totalSymptoms': 0,
        'activeSymptoms': 0,
        'severityBreakdown': {'low': 0, 'mild': 0, 'risky': 0},
        'mostCommonSpecialist': 'None',
        'healthTrend': 'No data available',
      };
    }

    final activeSymptoms = allSymptoms.where((s) => s.isActive).length;
    final severityBreakdown = <String, int>{'low': 0, 'mild': 0, 'risky': 0};

    for (final symptom in allSymptoms) {
      severityBreakdown[symptom.severity] =
          (severityBreakdown[symptom.severity] ?? 0) + 1;
    }

    // Find most common specialist
    final specialistCount = <String, int>{};
    for (final symptom in allSymptoms) {
      specialistCount[symptom.recommendedSpecialist] =
          (specialistCount[symptom.recommendedSpecialist] ?? 0) + 1;
    }

    final mostCommonSpecialist =
        specialistCount.entries.reduce((a, b) => a.value > b.value ? a : b).key;

    // Determine health trend
    String healthTrend = 'Stable';
    if (severityBreakdown['risky']! > severityBreakdown['low']!) {
      healthTrend = 'Needs attention';
    } else if (severityBreakdown['low']! >
        severityBreakdown['mild']! + severityBreakdown['risky']!) {
      healthTrend = 'Improving';
    }

    return {
      'totalSymptoms': allSymptoms.length,
      'activeSymptoms': activeSymptoms,
      'severityBreakdown': severityBreakdown,
      'mostCommonSpecialist': mostCommonSpecialist,
      'healthTrend': healthTrend,
    };
  }
}
