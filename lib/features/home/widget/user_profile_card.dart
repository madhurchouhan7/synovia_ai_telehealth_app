import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:synovia_ai_telehealth_app/features/home/screens/notification_page.dart';
import 'package:synovia_ai_telehealth_app/utils/svg_assets.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfileCard extends StatelessWidget {
  const UserProfileCard({super.key, this.onProfileTap});
  final VoidCallback? onProfileTap;

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning ☀️';
    if (hour < 17) return 'Good Afternoon 🌤️';
    return 'Good Evening 🌙';
  }

  @override
  Widget build(BuildContext context) {
    // variable
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth / 600;

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEEE, d MMMM yyyy').format(now);

    final user = FirebaseAuth.instance.currentUser;
    final displayName = user?.displayName ?? 'User';
    final photoUrl =
        user?.photoURL ??
        'https://img.freepik.com/free-photo/closeup-young-female-professional-making-eye-contact-against-colored-background_662251-651.jpg?semt=ais_hybrid&w=740';

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      color: Color(0xFF212C24),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(SvgAssets.ic_cal),

                    SizedBox(width: screenWidth * 0.02),
                    // 1. date
                    Text(
                      formattedDate,
                      style: GoogleFonts.nunito(
                        fontSize: 15,
                        color: Color(0xFFA4A9A4),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                // 2. notification icon
                InkWell(
                  onTap: () {
                    // Handle notification tap
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotificationPage(),
                      ),
                    );
                  },
                  child: SvgPicture.asset(
                    SvgAssets.ic_notification,
                    height: screenWidth * 0.11,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // 3. user profile image
                    CircleAvatar(
                      radius: screenWidth * 0.08,
                      backgroundImage: NetworkImage(photoUrl),
                    ),
                    SizedBox(width: screenWidth * 0.05),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 4. user name
                        Text(
                          'Hello, ${displayName.split(' ').first} ! 👋🏻',
                          style: GoogleFonts.nunito(
                            fontSize: 28 * fontSize,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        // 5. greetings
                        Text(
                          _getGreeting(),
                          style: GoogleFonts.nunito(
                            fontSize: 20 * fontSize,
                            color: Color(0xFFA4A9A4),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // 6. user profile details
                InkWell(
                  onTap: onProfileTap,
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(3.14),
                    child: SvgPicture.asset(
                      SvgAssets.left_back_icon,
                      // ignore: deprecated_member_use
                      color: Color(0xFFA4A9A4),
                      height: screenWidth * 0.07,
                    ),
                  ),
                ),
              ],
            ),

            // search bar
            SizedBox(height: screenWidth * 0.08),

            TextFormField(
              // controller: _emailController,
              style: GoogleFonts.nunito(color: Colors.white),
              key: ValueKey('email'),

              decoration: InputDecoration(
                fillColor: Color(0xFF414B44),
                filled: true,
                prefixIcon: Padding(
                  padding: EdgeInsets.only(left: 15, right: 5),
                  child: SvgPicture.asset(SvgAssets.ic_search_bold),
                ),
                hintText: "Search ",
                hintStyle: GoogleFonts.nunito(
                  color: Colors.white.withOpacity(0.6),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
