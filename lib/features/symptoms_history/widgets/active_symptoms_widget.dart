import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:synovia_ai_telehealth_app/core/colors.dart';
import 'package:synovia_ai_telehealth_app/features/symptoms_history/provider/symptoms_history_provider.dart';
import 'package:synovia_ai_telehealth_app/features/symptoms_history/screens/progress_page.dart';
import 'package:synovia_ai_telehealth_app/features/symptoms_history/widgets/symptom_card.dart';

class ActiveSymptomsWidget extends StatelessWidget {
  const ActiveSymptomsWidget({super.key});

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SymptomsHistoryProvider>(
      builder: (context, provider, child) {
        return RefreshIndicator(
          onRefresh: () async {
            await provider.loadActiveSymptoms();
          },
          child:
              provider.isLoading
                  ? Container(
                    height: 140,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 2,
                      itemBuilder:
                          (context, index) => Container(
                            width: 300,
                            margin: EdgeInsets.only(right: 12),
                            child: const SymptomCardSkeleton(),
                          ),
                    ),
                  )
                  : provider.activeSymptoms.isEmpty
                  ? Container(
                    padding: EdgeInsets.all(16),
                    //margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Color(0xFF2A332A),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green, size: 28),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'No Active Symptoms',
                                style: GoogleFonts.nunito(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'You\'re feeling healthy!',
                                style: GoogleFonts.nunito(
                                  color: lightTextColor,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                  : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          //horizontal: 16.0,
                          //vertical: 8.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Active Symptoms',
                              style: GoogleFonts.nunito(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProgressPage(),
                                  ),
                                );
                              },
                              child: Text(
                                'View All',
                                style: GoogleFonts.nunito(
                                  color: brandColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        // adapt height to content
                        height: 150,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          itemCount: provider.activeSymptoms.length,
                          itemBuilder: (context, index) {
                            final symptom = provider.activeSymptoms[index];
                            return Container(
                              width: 300,
                              margin: EdgeInsets.only(right: 12),
                              child: Card(
                                color: Color(0xFF2A332A),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            provider.getSeverityIcon(
                                              symptom.severity,
                                            ),
                                            color: provider.getSeverityColor(
                                              symptom.severity,
                                            ),
                                            size: 20,
                                          ),
                                          SizedBox(width: 6),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: provider
                                                  .getSeverityColor(
                                                    symptom.severity,
                                                  )
                                                  .withOpacity(0.2),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              symptom.severity.toUpperCase(),
                                              style: GoogleFonts.nunito(
                                                color: provider
                                                    .getSeverityColor(
                                                      symptom.severity,
                                                    ),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          Spacer(),
                                          Text(
                                            provider.formatDate(
                                              symptom.timestamp,
                                            ),
                                            style: GoogleFonts.nunito(
                                              color: lightTextColor,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        symptom.symptoms,
                                        style: GoogleFonts.nunito(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Recommended: ${symptom.recommendedSpecialist}',
                                        style: GoogleFonts.nunito(
                                          color: brandColor,
                                          fontSize: 14,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
        );
      },
    );
  }
}
