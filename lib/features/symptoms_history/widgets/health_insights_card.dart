import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:synovia_ai_telehealth_app/core/colors.dart';
import 'package:shimmer/shimmer.dart';

class HealthInsightsCard extends StatelessWidget {
  final Map<String, dynamic> insights;
  final double fontSize;

  const HealthInsightsCard({
    super.key,
    required this.insights,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFF2A332A),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.insights, color: brandColor, size: fontSize * 24),
                SizedBox(width: 8),
                Text(
                  'Health Insights',
                  style: GoogleFonts.nunito(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),

            // Statistics Row
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Total Symptoms',
                    insights['totalSymptoms']?.toString() ?? '0',
                    Icons.medical_services,
                    Colors.blue,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildStatItem(
                    'Active',
                    insights['activeSymptoms']?.toString() ?? '0',
                    Icons.warning,
                    Colors.orange,
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),

            // Severity Breakdown
            Text(
              'Severity Breakdown:',
              style: GoogleFonts.nunito(
                color: Colors.white,
                fontSize: fontSize * 26,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildSeverityItem(
                    'Low',
                    insights['severityBreakdown']?['low']?.toString() ?? '0',
                    Colors.green,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: _buildSeverityItem(
                    'Mild',
                    insights['severityBreakdown']?['mild']?.toString() ?? '0',
                    Colors.orange,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: _buildSeverityItem(
                    'Risky',
                    insights['severityBreakdown']?['risky']?.toString() ?? '0',
                    Colors.red,
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),

            // Health Trend and Most Common Specialist
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: _buildTrendItem(
                    'Health Trend',
                    insights['healthTrend']?.toString() ?? 'No data',
                    _getTrendIcon(insights['healthTrend']?.toString()),
                    _getTrendColor(insights['healthTrend']?.toString()),
                  ),
                ),

                Container(
                  child: _buildTrendItem(
                    'Most Common \nSpecialist',
                    insights['mostCommonSpecialist']?.toString() ?? 'None',
                    Icons.medical_services,
                    brandColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24), // Fixed size
          SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.nunito(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.nunito(color: lightTextColor, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSeverityItem(String label, String value, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.nunito(
              color: color,
              fontSize: 18, // Fixed size
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.nunito(
              color: lightTextColor,
              fontSize: 16, // Fixed size
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              SizedBox(width: 4),
              Text(
                overflow: TextOverflow.clip,
                label,
                style: GoogleFonts.nunito(
                  color: lightTextColor,
                  fontSize: fontSize * 20,
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            overflow: TextOverflow.clip,
            value,
            style: GoogleFonts.nunito(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  IconData _getTrendIcon(String? trend) {
    switch (trend?.toLowerCase()) {
      case 'improving':
        return Icons.trending_up;
      case 'needs attention':
        return Icons.trending_down;
      case 'stable':
        return Icons.trending_flat;
      default:
        return Icons.help;
    }
  }

  Color _getTrendColor(String? trend) {
    switch (trend?.toLowerCase()) {
      case 'improving':
        return Colors.green;
      case 'needs attention':
        return Colors.red;
      case 'stable':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}

class HealthInsightsCardSkeleton extends StatelessWidget {
  const HealthInsightsCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFF2A332A),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[800]!,
          highlightColor: Colors.grey[600]!,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(width: 28, height: 28, color: Colors.grey[700]),
                  SizedBox(width: 8),
                  Container(width: 120, height: 20, color: Colors.grey[700]),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Container(height: 60, color: Colors.grey[700]),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Container(height: 60, color: Colors.grey[700]),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Container(width: 140, height: 18, color: Colors.grey[700]),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Container(height: 40, color: Colors.grey[700]),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Container(height: 40, color: Colors.grey[700]),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Container(height: 40, color: Colors.grey[700]),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Container(height: 40, color: Colors.grey[700]),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Container(height: 40, color: Colors.grey[700]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
