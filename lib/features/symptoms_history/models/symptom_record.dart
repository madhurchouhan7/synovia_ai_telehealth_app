import 'package:cloud_firestore/cloud_firestore.dart';

class SymptomRecord {
  final String id;
  final String symptoms;
  final String severity; // 'low', 'mild', 'risky'
  final String aiAdvice;
  final String recommendedSpecialist;
  final DateTime timestamp;
  final bool isActive; // Whether this symptom is still active
  final String? followUpNotes; // User can add follow-up notes
  final DateTime? resolvedAt; // When the symptom was resolved

  SymptomRecord({
    required this.id,
    required this.symptoms,
    required this.severity,
    required this.aiAdvice,
    required this.recommendedSpecialist,
    required this.timestamp,
    this.isActive = true,
    this.followUpNotes,
    this.resolvedAt,
  });

  factory SymptomRecord.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SymptomRecord(
      id: doc.id,
      symptoms: data['symptoms'] ?? '',
      severity: data['severity'] ?? 'low',
      aiAdvice: data['aiAdvice'] ?? '',
      recommendedSpecialist:
          data['recommendedSpecialist'] ?? 'General Physician',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      isActive: data['isActive'] ?? true,
      followUpNotes: data['followUpNotes'],
      resolvedAt:
          data['resolvedAt'] != null
              ? (data['resolvedAt'] as Timestamp).toDate()
              : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'symptoms': symptoms,
      'severity': severity,
      'aiAdvice': aiAdvice,
      'recommendedSpecialist': recommendedSpecialist,
      'timestamp': Timestamp.fromDate(timestamp),
      'isActive': isActive,
      'followUpNotes': followUpNotes,
      'resolvedAt': resolvedAt != null ? Timestamp.fromDate(resolvedAt!) : null,
    };
  }

  SymptomRecord copyWith({
    String? id,
    String? symptoms,
    String? severity,
    String? aiAdvice,
    String? recommendedSpecialist,
    DateTime? timestamp,
    bool? isActive,
    String? followUpNotes,
    DateTime? resolvedAt,
  }) {
    return SymptomRecord(
      id: id ?? this.id,
      symptoms: symptoms ?? this.symptoms,
      severity: severity ?? this.severity,
      aiAdvice: aiAdvice ?? this.aiAdvice,
      recommendedSpecialist:
          recommendedSpecialist ?? this.recommendedSpecialist,
      timestamp: timestamp ?? this.timestamp,
      isActive: isActive ?? this.isActive,
      followUpNotes: followUpNotes ?? this.followUpNotes,
      resolvedAt: resolvedAt ?? this.resolvedAt,
    );
  }
}
