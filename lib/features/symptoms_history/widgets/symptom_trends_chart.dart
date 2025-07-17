import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:synovia_ai_telehealth_app/features/symptoms_history/models/symptom_record.dart';
import 'package:google_fonts/google_fonts.dart';

class SymptomTrendsChart extends StatelessWidget {
  final List<SymptomRecord> symptoms;
  final String periodLabel;
  final bool isLoading;

  const SymptomTrendsChart({
    super.key,
    required this.symptoms,
    required this.periodLabel,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
        height: 200,
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (symptoms.isEmpty) {
      return Container(
        height: 200,
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            'No data to display',
            style: GoogleFonts.nunito(color: Colors.white70, fontSize: 16),
          ),
        ),
      );
    }

    // Group symptoms by day and count or average severity
    final Map<String, List<SymptomRecord>> grouped = {};
    for (final s in symptoms) {
      final key = _dateKey(s.timestamp, periodLabel);
      grouped.putIfAbsent(key, () => []).add(s);
    }
    final sortedKeys = grouped.keys.toList()..sort();
    final spots = <FlSpot>[];
    int i = 0;
    for (final key in sortedKeys) {
      final records = grouped[key]!;
      // For demo: use average severity (1-3), fallback to count
      double y =
          records.isNotEmpty
              ? records
                      .map((e) => _severityToDouble(e.severity))
                      .reduce((a, b) => a + b) /
                  records.length
              : 0;
      spots.add(FlSpot(i.toDouble(), y));
      i++;
    }

    return Container(
      height: 200,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Symptom Trends',
            style: GoogleFonts.nunito(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true, drawVerticalLine: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true, reservedSize: 32),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx < 0 || idx >= sortedKeys.length)
                          return Container();
                        return Text(
                          sortedKeys[idx].substring(5),
                          style: GoogleFonts.nunito(
                            color: Colors.white70,
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: (spots.length - 1).toDouble(),
                minY: 1,
                maxY: 3,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: Colors.blueAccent,
                    barWidth: 3,
                    dotData: FlDotData(show: true),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _dateKey(DateTime dt, String periodLabel) {
    if (periodLabel == 'Today') {
      return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
    } else if (periodLabel == 'Last Week' || periodLabel == 'Last Month') {
      return '${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
    }
    return '${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }

  double _severityToDouble(String severity) {
    switch (severity.toLowerCase()) {
      case 'mild':
        return 1.0;
      case 'moderate':
        return 2.0;
      case 'severe':
        return 3.0;
      default:
        return 1.0;
    }
  }
}
