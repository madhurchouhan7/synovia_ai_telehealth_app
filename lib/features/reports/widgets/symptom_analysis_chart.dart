import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:synovia_ai_telehealth_app/features/symptoms_history/models/symptom_record.dart';
import 'package:synovia_ai_telehealth_app/core/colors.dart';

class SymptomAnalysisChart extends StatelessWidget {
  final List<SymptomRecord> symptoms;
  final bool isLoading;

  const SymptomAnalysisChart({
    super.key,
    required this.symptoms,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
        height: 340,
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
            'No symptoms data available',
            style: GoogleFonts.nunito(color: Colors.white70, fontSize: 16),
          ),
        ),
      );
    }

    final severityData = _getSeverityData();
    final riskyCount = _getSeverityCount('risky');
    final mildCount = _getSeverityCount('mild');
    final lowCount = _getSeverityCount('low');

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Symptom Analysis',
            style: GoogleFonts.nunito(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Severity Distribution',
                      style: GoogleFonts.nunito(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ), // Increased spacing to prevent overlap
                    SizedBox(
                      height: 120,
                      child: PieChart(
                        PieChartData(
                          sections:
                              severityData.map((data) {
                                return PieChartSectionData(
                                  value: data['count'].toDouble(),
                                  title: '${data['count']}',
                                  color: data['color'],
                                  radius: 50,
                                  titleStyle: GoogleFonts.nunito(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              }).toList(),
                          centerSpaceRadius: 30,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...severityData.map(
                      (data) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: data['color'],
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              data['label'],
                              style: GoogleFonts.nunito(
                                color: Colors.white70,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(child: _buildSymptomFrequencyChart()),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Severity Counts',
            style: GoogleFonts.nunito(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          _buildSeverityBarChart(riskyCount, mildCount, lowCount),
        ],
      ),
    );
  }

  Widget _buildSymptomFrequencyChart() {
    final frequencyData = _getSymptomFrequencyData();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Most Common Symptoms',
          style: GoogleFonts.nunito(
            color: Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 120,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY:
                  frequencyData.isNotEmpty
                      ? frequencyData
                              .map((d) => d['count'].toDouble())
                              .reduce((a, b) => a > b ? a : b) +
                          1
                      : 10,
              barTouchData: BarTouchData(enabled: false),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: GoogleFonts.nunito(
                          color: Colors.white70,
                          fontSize: 10,
                        ),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() < frequencyData.length) {
                        final symptom = frequencyData[value.toInt()]['symptom'];
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            symptom.length > 8
                                ? '${symptom.substring(0, 8)}...'
                                : symptom,
                            style: GoogleFonts.nunito(
                              color: Colors.white70,
                              fontSize: 10,
                            ),
                          ),
                        );
                      }
                      return Container();
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
              barGroups:
                  frequencyData.asMap().entries.map((entry) {
                    final index = entry.key;
                    final data = entry.value;
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: data['count'].toDouble(),
                          color: brandColor,
                          width: 20,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    );
                  }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSeverityBarChart(int risky, int mild, int low) {
    final data = [
      {'label': 'Risky', 'count': risky, 'color': Colors.red},
      {'label': 'Mild', 'count': mild, 'color': Colors.orange},
      {'label': 'Low', 'count': low, 'color': Colors.green},
    ];
    return SizedBox(
      height: 60,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY:
              [risky, mild, low].reduce((a, b) => a > b ? a : b).toDouble() + 1,
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() < data.length) {
                    return Text(
                      data[value.toInt()]['label'] as String,
                      style: GoogleFonts.nunito(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    );
                  }
                  return Container();
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups:
              data.asMap().entries.map((entry) {
                final index = entry.key;
                final d = entry.value;
                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: (d['count'] as int).toDouble(),
                      color: d['color'] as Color,
                      width: 24,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                );
              }).toList(),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getSeverityData() {
    final severityCounts = <String, int>{};
    for (final symptom in symptoms) {
      severityCounts[symptom.severity.toLowerCase()] =
          (severityCounts[symptom.severity.toLowerCase()] ?? 0) + 1;
    }

    final colors = {
      'low': Colors.green,
      'mild': Colors.orange,
      'risky': Colors.red,
    };

    return severityCounts.entries.map((entry) {
      return {
        'label': entry.key[0].toUpperCase() + entry.key.substring(1),
        'count': entry.value,
        'color': colors[entry.key] ?? Colors.grey,
      };
    }).toList();
  }

  int _getSeverityCount(String severity) {
    return symptoms.where((s) => s.severity.toLowerCase() == severity).length;
  }

  List<Map<String, dynamic>> _getSymptomFrequencyData() {
    final symptomCounts = <String, int>{};
    for (final symptom in symptoms) {
      symptomCounts[symptom.symptoms] =
          (symptomCounts[symptom.symptoms] ?? 0) + 1;
    }

    final sortedSymptoms =
        symptomCounts.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

    return sortedSymptoms.take(5).map((entry) {
      return {'symptom': entry.key, 'count': entry.value};
    }).toList();
  }
}
