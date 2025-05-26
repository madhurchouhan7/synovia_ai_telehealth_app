import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:synovia_ai_telehealth_app/core/colors.dart';
import 'package:synovia_ai_telehealth_app/features/profile%20page/widgets/custom_profile_page_options.dart';
import 'package:synovia_ai_telehealth_app/utils/svg_assets.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth / 600;
    final user = FirebaseAuth.instance.currentUser;
    final photoUrl =
        user?.photoURL ??
        'https://img.freepik.com/free-photo/closeup-young-female-professional-making-eye-contact-against-colored-background_662251-651.jpg?semt=ais_hybrid&w=740';

    return Scaffold(
      backgroundColor: darkBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Profile Summary',
          style: GoogleFonts.nunito(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Color(0xFF212C24),
      ),
      body: Expanded(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stack for background and profile photo
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        'https://img.freepik.com/premium-photo/school-hallway-architecture-corridor-building_53876-424946.jpg',
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 200,
                            color: lightTextColor,
                            child: Center(
                              child: Icon(
                                Icons.broken_image,
                                color: Colors.white54,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: -50,
                      child: Center(
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.black,
                          backgroundImage: NetworkImage(photoUrl),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 70),

                // User details
                Text(
                  user?.displayName ?? 'User Name',
                  style: GoogleFonts.nunito(
                    color: Colors.white,
                    fontSize: fontSize * 35,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 67, 95, 68),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          '💚 85% Healthy',
                          style: GoogleFonts.nunito(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: fontSize * 22,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 14),

                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 109, 78, 38),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          '⭐ Pro Member',
                          style: GoogleFonts.nunito(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: fontSize * 22,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // age
                    Column(
                      children: [
                        Text(
                          'Age',
                          style: GoogleFonts.nunito(
                            color: lightTextColor,
                            fontSize: fontSize * 25,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '25 yr', // Replace with actual age
                          style: GoogleFonts.nunito(
                            color: Colors.white,
                            fontSize: fontSize * 33,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    // Proper vertical divider using a fixed height and Container
                    Container(height: 40, width: 1, color: Colors.grey),
                    // height
                    Column(
                      children: [
                        Text(
                          'Height',
                          style: GoogleFonts.nunito(
                            color: lightTextColor,
                            fontSize: fontSize * 25,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '170 cm', // Replace with actual height
                          style: GoogleFonts.nunito(
                            color: Colors.white,
                            fontSize: fontSize * 33,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    Container(height: 40, width: 1, color: Colors.grey),
                    // weight
                    Column(
                      children: [
                        Text(
                          'Weight',
                          style: GoogleFonts.nunito(
                            color: lightTextColor,
                            fontSize: fontSize * 25,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '60 kg',
                          style: GoogleFonts.nunito(
                            color: Colors.white,
                            fontSize: fontSize * 33,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 20),

                // Custom profile page options
                Text(
                  'General',
                  style: GoogleFonts.nunito(
                    color: Colors.white,
                    fontSize: fontSize * 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                CustomProfilePageOptions(
                  text: 'Personal Information',
                  svgAsset: SvgAssets.ic_add,
                ),

                CustomProfilePageOptions(
                  text: 'Medical History',
                  svgAsset: SvgAssets.ic_cal,
                ),

                CustomProfilePageOptions(
                  text: 'Language',
                  svgAsset: SvgAssets.ic_cal,
                ),

                CustomProfilePageOptions(
                  text: 'Dark Mode',
                  svgAsset: SvgAssets.ic_notification,
                ),

                CustomProfilePageOptions(
                  text: 'Liked Devices',
                  svgAsset: SvgAssets.ic_search_bold,
                ),

                CustomProfilePageOptions(
                  text: 'Smart Notifications',
                  svgAsset: SvgAssets.ic_notification,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final shouldLogout = await showDialog<bool>(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: Text(
                    'Logout',
                    style: GoogleFonts.nunito(color: Colors.white),
                  ),
                  content: Text(
                    'Are you sure you want to logout?',
                    style: GoogleFonts.nunito(color: lightTextColor),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.nunito(color: brandColor),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text(
                        'Logout',
                        style: GoogleFonts.nunito(color: brandColor),
                      ),
                    ),
                  ],
                ),
          );
          if (shouldLogout == true) {
            await FirebaseAuth.instance.signOut();
          }
        },
        backgroundColor: brandColor,
        child: Icon(Icons.logout_outlined, color: Colors.black),
      ),
    );
  }
}
