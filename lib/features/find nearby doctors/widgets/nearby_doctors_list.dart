// lib/widgets/nearby_doctors_list.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:synovia_ai_telehealth_app/core/colors.dart';
import 'package:synovia_ai_telehealth_app/features/find%20nearby%20doctors/models/doctor_model.dart';
import 'package:synovia_ai_telehealth_app/features/find%20nearby%20doctors/services/doctor_search_service.dart';
import 'package:synovia_ai_telehealth_app/features/find%20nearby%20doctors/widgets/doctor_card.dart';
// Corrected path to your DoctorCard

class NearbyDoctorsList extends StatefulWidget {
  final String recommendedSpecialist;
  final List<Doctor> doctors;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback onRefresh;

  NearbyDoctorsList({
    super.key,
    required this.recommendedSpecialist,
    required this.doctors,
    required this.isLoading,
    this.errorMessage,
    required this.onRefresh,
  });

  @override
  State<NearbyDoctorsList> createState() => _NearbyDoctorsListState();
}

class _NearbyDoctorsListState extends State<NearbyDoctorsList> {
  final DoctorSearchService _doctorSearchService = DoctorSearchService();
  bool _showAllDoctors = false;

  @override
  void didUpdateWidget(covariant NearbyDoctorsList oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reset _showAllDoctors to false if the list of doctors changes
    // This ensures that when new search results come in, it defaults to showing only 5
    if (oldWidget.doctors != widget.doctors) {
      _showAllDoctors = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    print(
      'NearbyDoctorsList: Received recommendedSpecialist: ${widget.recommendedSpecialist}',
    );
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = MediaQuery.of(context).size.width / 600;

    // Determine the text for the doctor count
    String doctorCountText;
    if (widget.isLoading) {
      doctorCountText = ''; // No count while loading
    } else if (widget.doctors.isEmpty) {
      doctorCountText = '0';
    } else {
      doctorCountText = '${widget.doctors.length}+';
    }

    // Determine the content to display below the header based on loading/error/data
    Widget contentWidget;
    if (widget.isLoading) {
      contentWidget = Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: LoadingAnimationWidget.staggeredDotsWave(
            color: Colors.white,
            size: 40,
          ),
        ),
      );
    } else if (widget.errorMessage != null) {
      contentWidget = Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Text(
          widget.errorMessage!,
          style: GoogleFonts.nunito(color: Colors.red, fontSize: fontSize * 20),
          textAlign: TextAlign.center,
        ),
      );
    } else if (widget.doctors.isEmpty) {
      contentWidget = Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Text(
          'No nearby doctors found for "${widget.recommendedSpecialist}".',
          style: GoogleFonts.nunito(
            color: lightTextColor,
            fontSize: fontSize * 20,
          ),
          textAlign: TextAlign.center,
        ),
      );
    } else {
      final int doctorsToShow = _showAllDoctors ? widget.doctors.length : 5;
      final bool hasMoreDoctors = widget.doctors.length > 5;

      // --- CRITICAL FIX: Wrap ListView.builder and "See More" button in a Column ---
      contentWidget = Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: doctorsToShow,
            itemBuilder: (context, index) {
              final doctor = widget.doctors[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: DoctorCard(
                  doctorName: doctor.name,
                  doctorSpecialization: widget.recommendedSpecialist,
                  doctorRating:
                      doctor.rating != null
                          ? '${doctor.rating!.toStringAsFixed(1)}'
                          : 'N/A',
                  doctorTiming: 'Check timings with clinic',
                  doctorImageUrl:
                      doctor.photoReference != null
                          ? _doctorSearchService.getPhotoUrl(
                            doctor.photoReference!,
                          )!
                          : 'https://stvincentipa.com/wp-content/uploads/2022/11/Doctor-placeholder-male.jpg',
                  phoneNumber: doctor.phoneNumber,
                  openingHours: doctor.openingHours,
                ),
              );
            },
          ),
          // --- "See More" button is now correctly placed as a sibling to ListView.builder ---
          if (hasMoreDoctors && !_showAllDoctors)
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _showAllDoctors = true;
                  });
                },
                child: Text(
                  'See More (${widget.doctors.length - 5} more)',
                  style: GoogleFonts.nunito(
                    color: lightTextColor,
                    fontSize: fontSize * 20,
                  ),
                ),
              ),
            ),
        ],
      );
    }

    return Card(
      color: const Color(0xFF414B44),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  // Use Expanded to prevent text overflow in the Row
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Dynamic Doctor Count
                      Text(
                        doctorCountText,
                        style: GoogleFonts.nunito(
                          color: Colors.white,
                          fontSize: fontSize * 50,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Doctors Available text
                      Text(
                        'Doctors Available',
                        style: GoogleFonts.nunito(
                          color: lightTextColor,
                          fontSize: fontSize * 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.local_hospital_rounded,
                    color: Colors.white,
                    size: screenWidth / 10,
                  ),
                ),
                // Add a refresh button here if you want it next to the header
                // Otherwise, the refresh button passed via onRefresh is expected to be handled by the parent
              ],
            ),

            const SizedBox(height: 6.0),

            // Conditional content: loading, error, no doctors text, or doctor list
            contentWidget,

            // Add a refresh button at the bottom of the card if you want
            // If the onRefresh callback is primarily for the parent (HomePage's AppBar)
            // you might not need a second one here, or replace the IconButton in the Row.
            if (!widget.isLoading && widget.doctors.isNotEmpty ||
                widget.doctors.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: OutlinedButton(
                  onPressed: widget.onRefresh,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white54),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Refresh Doctors',
                    style: GoogleFonts.nunito(color: Colors.white70),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
