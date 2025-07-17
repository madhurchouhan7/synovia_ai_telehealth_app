import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:synovia_ai_telehealth_app/core/colors.dart';
import 'package:synovia_ai_telehealth_app/features/symptoms_history/models/symptom_record.dart';
import 'package:synovia_ai_telehealth_app/features/symptoms_history/provider/symptoms_history_provider.dart';
import 'package:shimmer/shimmer.dart';

class SymptomCard extends StatelessWidget {
  final SymptomRecord symptom;
  final VoidCallback onResolved;
  final Function(String) onAddNotes;

  const SymptomCard({
    super.key,
    required this.symptom,
    required this.onResolved,
    required this.onAddNotes,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth / 600;
    final provider = context.read<SymptomsHistoryProvider>();

    return Card(
      color: Color(0xFF2A332A),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with severity and date
            Row(
              children: [
                Icon(
                  provider.getSeverityIcon(symptom.severity),
                  color: provider.getSeverityColor(symptom.severity),
                  size: 25,
                ),
                SizedBox(width: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: provider
                        .getSeverityColor(symptom.severity)
                        .withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    symptom.severity.toUpperCase(),
                    style: GoogleFonts.nunito(
                      color: provider.getSeverityColor(symptom.severity),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Spacer(),
                Text(
                  provider.formatDate(symptom.timestamp),
                  style: GoogleFonts.nunito(
                    color: lightTextColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),

            SizedBox(height: 12),

            // Symptoms
            Text(
              'Symptoms:',
              style: GoogleFonts.nunito(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 4),
            Text(
              symptom.symptoms,
              style: GoogleFonts.nunito(color: lightTextColor, fontSize: 18),
            ),

            SizedBox(height: 12),

            // AI Advice
            Text(
              'AI Advice:',
              style: GoogleFonts.nunito(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 4),
            Text(
              symptom.aiAdvice,
              style: GoogleFonts.nunito(color: lightTextColor, fontSize: 16),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),

            SizedBox(height: 12),

            // Specialist
            Row(
              children: [
                Icon(Icons.medical_services, color: brandColor, size: 20),
                SizedBox(width: 8),
                Text(
                  'Recommended: ${symptom.recommendedSpecialist}',
                  style: GoogleFonts.nunito(
                    color: brandColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            // Follow-up notes if exists
            if (symptom.followUpNotes != null &&
                symptom.followUpNotes!.isNotEmpty) ...[
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: brandColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Follow-up Notes:',
                      style: GoogleFonts.nunito(
                        color: brandColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      symptom.followUpNotes!,
                      style: GoogleFonts.nunito(
                        color: lightTextColor,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            SizedBox(height: 16),

            // Action buttons
            Row(
              children: [
                if (symptom.isActive)
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _showResolveDialog(context),
                      icon: Icon(
                        Icons.check_circle,
                        size: 16,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Mark Resolved',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.nunito(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                if (symptom.isActive) SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showAddNotesDialog(context),
                    icon: Icon(Icons.note_add, size: 16, color: brandColor),
                    label: Text(
                      'Add Notes',
                      style: GoogleFonts.nunito(fontSize: 16),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: brandColor,
                      side: BorderSide(color: brandColor),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showResolveDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Color(0xFF2A332A),
            title: Text(
              'Mark as Resolved',
              style: GoogleFonts.nunito(color: Colors.white),
            ),
            content: Text(
              'Are you sure you want to mark this symptom as resolved?',
              style: GoogleFonts.nunito(color: lightTextColor),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: GoogleFonts.nunito(color: lightTextColor),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  onResolved();
                },
                child: Text('Resolve', style: GoogleFonts.nunito()),
              ),
            ],
          ),
    );
  }

  void _showAddNotesDialog(BuildContext context) {
    final TextEditingController notesController = TextEditingController(
      text: symptom.followUpNotes ?? '',
    );

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Color(0xFF2A332A),
            title: Text(
              'Add Follow-up Notes',
              style: GoogleFonts.nunito(color: Colors.white),
            ),
            content: TextField(
              controller: notesController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Enter your follow-up notes...',
                hintStyle: GoogleFonts.nunito(color: lightTextColor),
                border: OutlineInputBorder(),
              ),
              style: GoogleFonts.nunito(color: Colors.white),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: GoogleFonts.nunito(color: lightTextColor),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  onAddNotes(notesController.text);
                },
                child: Text('Save', style: GoogleFonts.nunito()),
              ),
            ],
          ),
    );
  }
}

class SymptomCardSkeleton extends StatelessWidget {
  const SymptomCardSkeleton({super.key});

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
                  Container(width: 24, height: 24, color: Colors.grey[700]),
                  SizedBox(width: 8),
                  Container(width: 60, height: 16, color: Colors.grey[700]),
                  Spacer(),
                  Container(width: 50, height: 14, color: Colors.grey[700]),
                ],
              ),
              SizedBox(height: 12),
              Container(width: 80, height: 16, color: Colors.grey[700]),
              SizedBox(height: 4),
              Container(
                width: double.infinity,
                height: 14,
                color: Colors.grey[700],
              ),
              SizedBox(height: 12),
              Container(width: 80, height: 16, color: Colors.grey[700]),
              SizedBox(height: 4),
              Container(
                width: double.infinity,
                height: 14,
                color: Colors.grey[700],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Container(width: 18, height: 18, color: Colors.grey[700]),
                  SizedBox(width: 8),
                  Container(width: 120, height: 14, color: Colors.grey[700]),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Container(height: 36, color: Colors.grey[700]),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Container(height: 36, color: Colors.grey[700]),
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
