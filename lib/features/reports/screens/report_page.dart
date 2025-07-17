import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:synovia_ai_telehealth_app/core/colors.dart';
import 'package:synovia_ai_telehealth_app/features/symptoms_history/provider/symptoms_history_provider.dart';
import 'package:synovia_ai_telehealth_app/features/symptoms_history/models/symptom_record.dart';
import 'package:synovia_ai_telehealth_app/features/reports/widgets/symptom_analysis_chart.dart';
import 'package:synovia_ai_telehealth_app/features/reports/widgets/ai_chat_insights_card.dart';
import 'package:synovia_ai_telehealth_app/features/reports/widgets/ai_insights_summary_card.dart';
import 'package:fl_chart/fl_chart.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  String _selectedRange = 'Last 30 days';
  final List<String> _ranges = ['Last 7 days', 'Last 30 days', 'All time'];

  List<SymptomRecord> _filterByRange(List<SymptomRecord> all) {
    final now = DateTime.now();
    if (_selectedRange == 'Last 7 days') {
      return all.where((s) => now.difference(s.timestamp).inDays < 7).toList();
    } else if (_selectedRange == 'Last 30 days') {
      return all.where((s) => now.difference(s.timestamp).inDays < 30).toList();
    }
    return all;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SymptomsHistoryProvider>().loadSymptomsHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackgroundColor,
      appBar: AppBar(
        backgroundColor: Color(0xFF212C24),
        centerTitle: true,
        title: Text(
          'Health Reports',
          style: GoogleFonts.nunito(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 24,
          ),
        ),
      ),
      body: Consumer<SymptomsHistoryProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: brandColor),
            );
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 80),
                  SizedBox(height: 16),
                  Text(
                    'Error loading reports',
                    style: GoogleFonts.nunito(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    provider.error!,
                    style: GoogleFonts.nunito(
                      color: lightTextColor,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.loadSymptomsHistory(),
                    child: Text(
                      'Retry',
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          final allSymptoms = provider.allSymptoms.cast<SymptomRecord>();
          final filteredSymptoms = _filterByRange(allSymptoms);

          return RefreshIndicator(
            color: brandColor,
            onRefresh: () async {
              await provider.loadSymptomsHistory();
            },
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Date Range:',
                          style: GoogleFonts.nunito(
                            color: Colors.white70,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(width: 12),
                        DropdownButton<String>(
                          value: _selectedRange,
                          dropdownColor: Colors.grey[900],
                          style: GoogleFonts.nunito(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                          items:
                              _ranges
                                  .map(
                                    (r) => DropdownMenuItem(
                                      value: r,
                                      child: Text(r),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (val) {
                            if (val != null)
                              setState(() => _selectedRange = val);
                          },
                        ),
                      ],
                    ),
                  ),
                  AiInsightsSummaryCard(
                    symptoms: filteredSymptoms,
                    dateRangeLabel: _selectedRange,
                  ),
                  _TrendsLineChart(symptoms: filteredSymptoms),
                  SymptomAnalysisChart(
                    symptoms: filteredSymptoms,
                    isLoading: provider.isLoading,
                  ),
                  AiChatInsightsCard(
                    symptoms: filteredSymptoms,
                    isLoading: provider.isLoading,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TrendsLineChart extends StatelessWidget {
  final List<SymptomRecord> symptoms;
  const _TrendsLineChart({required this.symptoms});

  @override
  Widget build(BuildContext context) {
    if (symptoms.isEmpty) return SizedBox.shrink();
    final Map<String, int> dayCounts = {};
    final Map<String, int> adviceCounts = {};
    for (final s in symptoms) {
      final day = '${s.timestamp.month}/${s.timestamp.day}';
      dayCounts[day] = (dayCounts[day] ?? 0) + 1;
      final advice = _getAdviceType(s.aiAdvice);
      adviceCounts['$day-$advice'] = (adviceCounts['$day-$advice'] ?? 0) + 1;
    }
    final sortedDays =
        dayCounts.keys.toList()..sort((a, b) {
          final aParts = a.split('/').map(int.parse).toList();
          final bParts = b.split('/').map(int.parse).toList();
          return DateTime(
            2023,
            aParts[0],
            aParts[1],
          ).compareTo(DateTime(2023, bParts[0], bParts[1]));
        });
    final spots = <FlSpot>[];
    for (int i = 0; i < sortedDays.length; i++) {
      spots.add(FlSpot(i.toDouble(), dayCounts[sortedDays[i]]!.toDouble()));
    }
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
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
          const SizedBox(height: 12),
          SizedBox(
            height: 160,
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
                        if (idx < 0 || idx >= sortedDays.length)
                          return Container();
                        return Text(
                          sortedDays[idx],
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
                minY: 0,
                maxY:
                    spots
                        .map((e) => e.y)
                        .fold<double>(0, (prev, y) => y > prev ? y : prev) +
                    1,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: brandColor,
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
