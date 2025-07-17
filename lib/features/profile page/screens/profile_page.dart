// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:synovia_ai_telehealth_app/core/colors.dart';
import 'package:synovia_ai_telehealth_app/features/profile%20page/widgets/custom_profile_page_options.dart';
import 'package:synovia_ai_telehealth_app/utils/svg_assets.dart';
import 'dart:developer' as developer;

class _PersonalInfoForm extends StatefulWidget {
  @override
  State<_PersonalInfoForm> createState() => _PersonalInfoFormState();
}

class _PersonalInfoFormState extends State<_PersonalInfoForm> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _age = '';
  String _gender = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            style: GoogleFonts.nunito(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Name',
              labelStyle: GoogleFonts.nunito(color: Colors.white70),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white24),
              ),
            ),
            onChanged: (val) => _name = val,
          ),
          const SizedBox(height: 12),
          TextFormField(
            style: GoogleFonts.nunito(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Age',
              labelStyle: GoogleFonts.nunito(color: Colors.white70),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white24),
              ),
            ),
            keyboardType: TextInputType.number,
            onChanged: (val) => _age = val,
          ),
          const SizedBox(height: 12),
          TextFormField(
            style: GoogleFonts.nunito(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Gender',
              labelStyle: GoogleFonts.nunito(color: Colors.white70),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white24),
              ),
            ),
            onChanged: (val) => _gender = val,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Personal information updated!',
                      style: GoogleFonts.nunito(),
                    ),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: brandColor),
            child: Text('Save', style: GoogleFonts.nunito(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _MedicalHistoryForm extends StatefulWidget {
  @override
  State<_MedicalHistoryForm> createState() => _MedicalHistoryFormState();
}

class _MedicalHistoryFormState extends State<_MedicalHistoryForm> {
  final _formKey = GlobalKey<FormState>();
  String _conditions = '';
  String _allergies = '';
  String _medications = '';
  String _surgeries = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            style: GoogleFonts.nunito(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Conditions',
              labelStyle: GoogleFonts.nunito(color: Colors.white70),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white24),
              ),
            ),
            onChanged: (val) => _conditions = val,
          ),
          const SizedBox(height: 12),
          TextFormField(
            style: GoogleFonts.nunito(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Allergies',
              labelStyle: GoogleFonts.nunito(color: Colors.white70),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white24),
              ),
            ),
            onChanged: (val) => _allergies = val,
          ),
          const SizedBox(height: 12),
          TextFormField(
            style: GoogleFonts.nunito(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Medications',
              labelStyle: GoogleFonts.nunito(color: Colors.white70),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white24),
              ),
            ),
            onChanged: (val) => _medications = val,
          ),
          const SizedBox(height: 12),
          TextFormField(
            style: GoogleFonts.nunito(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Surgeries',
              labelStyle: GoogleFonts.nunito(color: Colors.white70),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white24),
              ),
            ),
            onChanged: (val) => _surgeries = val,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Medical history updated!',
                      style: GoogleFonts.nunito(),
                    ),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: brandColor),
            child: Text('Save', style: GoogleFonts.nunito(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    user?.displayName ?? 'User Name',
                    style: GoogleFonts.nunito(
                      color: Colors.white,
                      fontSize: fontSize * 38,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                '\tGeneral',
                style: GoogleFonts.nunito(
                  color: Colors.white,
                  fontSize: fontSize * 25,
                  fontWeight: FontWeight.w700,
                ),
              ),

              CustomProfilePageOptions(
                text: 'Personal Information',
                child: SvgPicture.asset(SvgAssets.ic_user, color: Colors.white),
                onTap: () => _showPersonalInfoSheet(context),
              ),

              CustomProfilePageOptions(
                text: 'Medical History',
                child: SvgPicture.asset(
                  SvgAssets.ic_health_plus,
                  color: Colors.white,
                ),
                onTap: () => _showMedicalHistorySheet(context),
              ),

              CustomProfilePageOptions(
                text: 'Language Preference',
                child: SvgPicture.asset(SvgAssets.ic_flag, color: Colors.white),
              ),

              CustomProfilePageOptions(
                text: 'Dark Mode',
                child: SvgPicture.asset(SvgAssets.ic_moon, color: Colors.white),
              ),

              SizedBox(height: 20),

              Text(
                '\tSecurity & Privacy',
                style: GoogleFonts.nunito(
                  color: Colors.white,
                  fontSize: fontSize * 25,
                  fontWeight: FontWeight.w700,
                ),
              ),

              CustomProfilePageOptions(
                text: 'Privacy Policy',
                child: SvgPicture.asset(
                  SvgAssets.ic_shield,
                  color: Colors.white,
                ),
              ),

              CustomProfilePageOptions(
                text: 'Security Settings',
                child: SvgPicture.asset(SvgAssets.ic_lock, color: Colors.white),
              ),

              SizedBox(height: 20),

              Text(
                '\tDanger Zone',
                style: GoogleFonts.nunito(
                  color: Colors.white,
                  fontSize: fontSize * 25,
                  fontWeight: FontWeight.w700,
                ),
              ),

              Card(
                color: Colors.red[900],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 12.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 1. Doctor's Image
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            // svg icon
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.0),
                                color: Colors.red[600],
                              ),
                              width: screenWidth / 8,
                              height: screenWidth / 8,

                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: SvgPicture.asset(
                                  SvgAssets.ic_trash,
                                  color: Colors.white,
                                ),
                              ),
                            ),

                            SizedBox(width: screenWidth / 30),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 1. Doctor's Name
                                Text(
                                  'Close Account',
                                  style: GoogleFonts.nunito(
                                    color: Colors.white,
                                    fontSize: fontSize * 24,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // 2. Doctor's Details icon
                      Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(3.14),
                        child: SvgPicture.asset(
                          SvgAssets.left_back_icon,
                          // ignore: deprecated_member_use
                          color: Color(0xFFA4A9A4),
                          height: screenWidth * 0.05,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: screenWidth / 10),

              Center(
                child: SvgPicture.asset(
                  SvgAssets.logo_mark,
                  height: screenWidth * 0.1,
                ),
              ),

              SizedBox(height: screenWidth / 20),

              Center(
                child: Text(
                  'Synovia AI Version 1.0.0',
                  style: GoogleFonts.nunito(
                    color: lightTextColor,
                    fontSize: fontSize * 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
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
            developer.log('🔓 User signed out');
          }
        },
        backgroundColor: brandColor,
        child: Icon(Icons.logout_outlined, color: Colors.black),
      ),
    );
  }

  void _showPersonalInfoSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder:
          (context) => Padding(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 24,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Edit Personal Information',
                  style: GoogleFonts.nunito(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 16),
                _PersonalInfoForm(),
              ],
            ),
          ),
    );
  }

  void _showMedicalHistorySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder:
          (context) => Padding(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 24,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Medical History',
                  style: GoogleFonts.nunito(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 16),
                _MedicalHistoryForm(),
              ],
            ),
          ),
    );
  }
}
