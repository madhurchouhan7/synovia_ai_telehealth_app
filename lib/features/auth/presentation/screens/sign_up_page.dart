import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:synovia_ai_telehealth_app/config/routes.dart';
import 'package:synovia_ai_telehealth_app/core/colors.dart';
import 'package:synovia_ai_telehealth_app/features/auth/presentation/screens/sign_in_page.dart';
import 'package:synovia_ai_telehealth_app/features/auth/presentation/widgets/cta_button.dart';
import 'package:synovia_ai_telehealth_app/utils/svg_assets.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  var isObsecured;

  @override
  void initState() {
    super.initState();
    isObsecured = false;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth / 600;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: darkBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(right: 20, left: 20, top: 40, bottom: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // logo
              SvgPicture.asset(SvgAssets.logo_mark),

              // title
              Text(
                'Sign Up for Free',
                style: GoogleFonts.nunito(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 55 * fontSize,
                ),
              ),

              // subtitle
              Text(
                'Create an account and unlock personalized health insights.',
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  color: lightTextColor,
                  fontSize: 25 * fontSize,
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // email field
                  Text(
                    'Email Address',
                    style: GoogleFonts.nunito(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25 * fontSize,
                    ),
                  ),

                  SizedBox(height: 5),

                  // email
                  TextFormField(
                    style: GoogleFonts.nunito(color: Colors.white),
                    //controller: _emailController,
                    key: ValueKey('email'),
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(left: 15, right: 5),
                        child: SvgPicture.asset(SvgAssets.email),
                      ),
                      hintText: "Enter email",
                      hintStyle: TextStyle(color: lightTextColor),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: brandColor),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: brandColor),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  SizedBox(height: screenWidth * 0.05),

                  // password field
                  Text(
                    'Password',
                    style: GoogleFonts.nunito(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25 * fontSize,
                    ),
                  ),

                  SizedBox(height: 5),

                  // password field
                  TextFormField(
                    style: GoogleFonts.nunito(color: Colors.white),
                    // controller: _passwordController,
                    key: ValueKey('password_confirm'),
                    obscureText: isObsecured,
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(left: 15, right: 5),
                        child: SvgPicture.asset(SvgAssets.password),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isObsecured ? Icons.visibility : Icons.visibility_off,
                          color: lightTextColor,
                        ),
                        onPressed: () {
                          setState(() {
                            isObsecured = !isObsecured;
                          });
                        },
                        color: Colors.white,
                      ),
                      hintText: "Enter your password...",
                      hintStyle: TextStyle(color: lightTextColor),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: brandColor),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: brandColor),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(height: screenWidth * 0.05),

                  Text(
                    'Password Confirmation',
                    style: GoogleFonts.nunito(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25 * fontSize,
                    ),
                  ),
                  SizedBox(height: 5),

                  // password field
                  TextFormField(
                    style: GoogleFonts.nunito(color: Colors.white),
                    // controller: _passwordController,
                    key: ValueKey('password'),
                    obscureText: isObsecured,
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(left: 15, right: 5),
                        child: SvgPicture.asset(SvgAssets.password),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isObsecured ? Icons.visibility : Icons.visibility_off,
                          color: lightTextColor,
                        ),
                        onPressed: () {
                          setState(() {
                            isObsecured = !isObsecured;
                          });
                        },
                        color: Colors.white,
                      ),
                      hintText: "Enter your password...",
                      hintStyle: TextStyle(color: lightTextColor),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: brandColor),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: brandColor),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: screenWidth * 0.06),

              CtaButton(
                text: 'Sign Up',
                svgAssets: SvgAssets.solid_arrow_right_sm,
                onTap: null,
              ),

              SizedBox(
                width: screenWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?\t\t',
                      style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 25 * fontSize,
                      ),
                    ),

                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          pageRoute(SignInPage()),
                        );
                      },
                      child: Text(
                        'Sign In.',
                        style: GoogleFonts.nunito(
                          color: brandColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 25 * fontSize,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
