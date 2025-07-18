// lib/features/find nearby doctors/screens/doctor_detail_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:synovia_ai_telehealth_app/core/colors.dart';
import 'package:synovia_ai_telehealth_app/features/find%20nearby%20doctors/models/doctor_model.dart';
import 'package:synovia_ai_telehealth_app/features/find%20nearby%20doctors/services/doctor_search_service.dart';
import 'package:synovia_ai_telehealth_app/features/find%20nearby%20doctors/utils/opening_hours_util.dart';
import 'package:synovia_ai_telehealth_app/utils/svg_assets.dart';
import 'package:url_launcher/url_launcher.dart';

class DoctorDetailPage extends StatelessWidget {
  final Doctor doctor;
  final double? distanceInKm;

  const DoctorDetailPage({super.key, required this.doctor, this.distanceInKm});

  @override
  Widget build(BuildContext context) {
    final DoctorSearchService doctorSearchService = DoctorSearchService();
    final screenWidth = MediaQuery.of(context).size.width;

    final opeiningStatus = OpeningHoursUtil.getOpeningStatus(
      doctor.openingHours,
    );
    Color statusColor = Colors.grey;

    if (opeiningStatus.contains('Open Now')) {
      statusColor = Colors.green;
    } else if (opeiningStatus.contains('Closed')) {
      statusColor = Colors.red;
    } else if (opeiningStatus.contains('Hours not available')) {
      statusColor = Colors.orange;
    } else if (opeiningStatus.contains('Hours parsing error')) {
      statusColor = Colors.yellow;
    }

    return Scaffold(
      backgroundColor: darkBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          doctor.name,
          style: GoogleFonts.nunito(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Doctor Image
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child:
                    doctor.photoReference != null
                        ? Image.network(
                          doctorSearchService.getPhotoUrl(
                            doctor.photoReference!,
                          )!,
                          width: screenWidth * 0.8,
                          height: screenWidth * 0.6,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) => Image.network(
                                'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png',
                                fit: BoxFit.cover,
                              ),
                        )
                        : Image.network(
                          'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png',
                          fit: BoxFit.cover,
                        ),
              ),
            ),
            const SizedBox(height: 20),

            Text(
              doctor.name,
              style: GoogleFonts.nunito(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (distanceInKm != null)
              Padding(
                padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: brandColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.location_on, color: brandColor, size: 20),
                      const SizedBox(width: 6),
                      Text(
                        '${distanceInKm!.toStringAsFixed(1)} km away',
                        style: GoogleFonts.nunito(
                          color: brandColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            Divider(color: Colors.white.withOpacity(0.2), thickness: 1),

            const SizedBox(height: 8),
            // Rating and Total Ratings
            Row(
              children: [
                SvgPicture.asset(
                  SvgAssets.star,
                  colorFilter: ColorFilter.mode(Colors.yellow, BlendMode.srcIn),
                  width: 20,
                  height: 20,
                ),
                const SizedBox(width: 4),
                Text(
                  doctor.rating?.toStringAsFixed(1) ?? 'N/A',
                  style: GoogleFonts.nunito(
                    color: lightTextColor,
                    fontSize: 18,
                  ),
                ),
                if (doctor.userRatingsTotal != null) ...[
                  const SizedBox(width: 8),
                  Text(
                    '(${doctor.userRatingsTotal} reviews)',
                    style: GoogleFonts.nunito(
                      color: lightTextColor.withOpacity(0.7),
                      fontSize: 16,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 15),

            // Opening Status
            Card(
              color: statusColor,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      SvgAssets.clock,
                      colorFilter: ColorFilter.mode(
                        statusColor == Colors.green
                            ? Colors.white
                            : Colors.black,
                        BlendMode.srcIn,
                      ),
                      width: 20,
                      height: 20,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      opeiningStatus,
                      style: GoogleFonts.nunito(
                        color:
                            statusColor == Colors.green
                                ? Colors.white
                                : Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),

            // Address - Use formattedAddress if available, otherwise vicinity
            _buildDetailRow(
              context: context,
              svgAsses: SvgAssets.location,
              label: 'Address:',
              value: doctor.formattedAddress ?? doctor.vicinity ?? 'N/A',
            ),
            const SizedBox(height: 10),

            // Phone Number
            if (doctor.phoneNumber != null && doctor.phoneNumber!.isNotEmpty)
              _buildDetailRow(
                context: context, // <-- Pass context here
                svgAsses: SvgAssets.telephone,
                label: 'Phone:',
                value: doctor.phoneNumber!,
                isLink: true, // Make it tappable to call
              ),
            if (doctor.phoneNumber != null && doctor.phoneNumber!.isNotEmpty)
              const SizedBox(height: 10),

            // Opening Hours
            if (doctor.openingHours != null &&
                doctor.openingHours!.isNotEmpty) ...[
              Row(
                children: [
                  SvgPicture.asset(
                    SvgAssets.clock,
                    colorFilter: ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                    width: 20,
                    height: 20,
                  ),

                  const SizedBox(width: 10),
                  Text(
                    'Opening Hours:',
                    style: GoogleFonts.nunito(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              ...doctor.openingHours!
                  .map(
                    (hour) => Padding(
                      padding: const EdgeInsets.only(left: 30, bottom: 4.0),
                      child: Text(
                        hour,
                        style: GoogleFonts.nunito(
                          color: lightTextColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  )
                  .toList(),
              const SizedBox(height: 15),
            ],

            // Map Button
            Center(
              child: ElevatedButton.icon(
                onPressed: () async {
                  if (doctor.placeId != null) {
                    final url = Uri.parse(
                      'https://www.google.com/maps/search/?api=1&query=${doctor.latitude},${doctor.longitude}&query_place_id=${doctor.placeId}',
                    );
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    } else {
                      // Use a Builder to get a valid context for ScaffoldMessenger
                      ScaffoldMessenger.of(context).showSnackBar(
                        // Context is valid here
                        SnackBar(
                          content: Text(
                            'Could not launch map for ${doctor.name}',
                          ),
                        ),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      // Context is valid here
                      SnackBar(
                        content: Text(
                          'No map data available for ${doctor.name}',
                        ),
                      ),
                    );
                  }
                },
                icon: Icon(Icons.map, color: Colors.black),
                label: Text(
                  'View on Map',
                  style: GoogleFonts.nunito(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: brandColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required BuildContext context,
    required String svgAsses,
    required String label,
    required String value,
    bool isLink = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(
          svgAsses,
          colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
          width: 20,
          height: 20,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.nunito(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              isLink
                  ? Builder(
                    // <-- Use Builder to get a new context for the Snackbar
                    builder: (innerContext) {
                      // innerContext is guaranteed to be valid
                      return GestureDetector(
                        onTap: () async {
                          final url = Uri.parse('tel:$value');
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url);
                          } else {
                            ScaffoldMessenger.of(innerContext).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '⚠️ Could not make a phone call to $value',
                                ),
                              ),
                            );
                          }
                        },
                        child: Text(
                          value,
                          style: GoogleFonts.nunito(
                            color: Colors.blueAccent,
                            fontSize: 16,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      );
                    },
                  )
                  : Text(
                    value,
                    style: GoogleFonts.nunito(
                      color: lightTextColor,
                      fontSize: 16,
                    ),
                  ),
            ],
          ),
        ),
      ],
    );
  }
}
