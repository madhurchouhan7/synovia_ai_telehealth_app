import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:synovia_ai_telehealth_app/features/symptoms_history/models/symptom_record.dart';
import 'package:synovia_ai_telehealth_app/core/colors.dart';

class AiInsightsSummaryCard extends StatelessWidget {
  final List<SymptomRecord> symptoms;
  final String dateRangeLabel;

  const AiInsightsSummaryCard({
    super.key,
    required this.symptoms,
    required this.dateRangeLabel,
  });

  @override
  Widget build(BuildContext context) {
    final mostCommonSymptom = _getMostCommonSymptom();
    final mostFrequentAdvice = _getMostFrequentAdviceType();
    final riskyCount =
        symptoms.where((s) => s.severity.toLowerCase() == 'risky').length;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.blueGrey[900],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: brandColor.withOpacity(0.08),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.insights, color: brandColor, size: 28),
              const SizedBox(width: 8),
              Text(
                'Key Insights ($dateRangeLabel)',
                style: GoogleFonts.nunito(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _buildInsightRow('Most common symptom:', mostCommonSymptom),
          const SizedBox(height: 8),
          _buildInsightRow('Most frequent advice:', mostFrequentAdvice),
          const SizedBox(height: 8),
          _buildInsightRow('Risky symptoms detected:', riskyCount.toString()),
        ],
      ),
    );
  }

  Widget _buildInsightRow(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: GoogleFonts.nunito(
            color: Colors.white70,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.nunito(
              color: brandColor,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _getMostCommonSymptom() {
    if (symptoms.isEmpty) return '-';
    final counts = <String, int>{};
    for (final s in symptoms) {
      counts[s.symptoms] = (counts[s.symptoms] ?? 0) + 1;
    }
    final sorted =
        counts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    return sorted.isNotEmpty ? sorted.first.key : '-';
  }

  String _getMostFrequentAdviceType() {
    if (symptoms.isEmpty) return '-';
    final counts = <String, int>{};
    for (final s in symptoms) {
      final type = _getAdviceType(s.aiAdvice);
      counts[type] = (counts[type] ?? 0) + 1;
    }
    final sorted =
        counts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    return sorted.isNotEmpty ? sorted.first.key : '-';
  }

  String _getAdviceType(String aiAdvice) {
    final advice = aiAdvice.toLowerCase();
    if (advice.contains('doctor') ||
        advice.contains('specialist') ||
        advice.contains('emergency')) {
      return 'See Doctor';
    } else if (advice.contains('rest') ||
        advice.contains('hydration') ||
        advice.contains('self-care')) {
      return 'Self-care';
    } else if (advice.contains('monitor') || advice.contains('watch')) {
      return 'Monitor';
    }
    return 'Other';
  }
}
