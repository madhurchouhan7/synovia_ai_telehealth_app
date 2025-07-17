import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:synovia_ai_telehealth_app/features/symptoms_history/models/symptom_record.dart';

class PersonalizedHealthTipsCard extends StatelessWidget {
  final List<SymptomRecord> symptoms;
  final String periodLabel;

  const PersonalizedHealthTipsCard({
    super.key,
    required this.symptoms,
    required this.periodLabel,
  });

  @override
  Widget build(BuildContext context) {
    String tip = _generateTip(symptoms);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green[900],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.tips_and_updates, color: Colors.yellow[700], size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Personalized Health Tips',
                  style: GoogleFonts.nunito(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  tip,
                  style: GoogleFonts.nunito(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _generateTip(List<SymptomRecord> symptoms) {
    if (symptoms.isEmpty) {
      return 'No symptoms recorded for this period. Keep up the healthy habits!';
    }
    final hasSevere = symptoms.any((s) => s.severity.toLowerCase() == 'severe');
    final hasModerate = symptoms.any(
      (s) => s.severity.toLowerCase() == 'moderate',
    );
    final hasMild = symptoms.any((s) => s.severity.toLowerCase() == 'mild');
    if (hasSevere) {
      return 'Some of your symptoms are severe. Please consider consulting a healthcare professional as soon as possible.';
    } else if (hasModerate) {
      return 'You have some moderate symptoms. Monitor your condition closely and practice self-care. If symptoms worsen, seek medical advice.';
    } else if (hasMild) {
      return 'Your symptoms are mild. Make sure to rest, stay hydrated, and take care of yourself.';
    }
    return 'Keep tracking your health and stay proactive!';
  }
}
