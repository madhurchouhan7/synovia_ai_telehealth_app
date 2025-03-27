import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:synovia_ai_telehealth_app/config/routes.dart';
import 'package:synovia_ai_telehealth_app/core/colors.dart';
import 'package:synovia_ai_telehealth_app/features/auth/presentation/screens/forgot_password_page.dart';
import 'package:synovia_ai_telehealth_app/features/auth/presentation/screens/sign_up_page.dart';
import 'package:synovia_ai_telehealth_app/features/auth/presentation/widgets/cta_button.dart';
import 'package:synovia_ai_telehealth_app/features/auth/presentation/widgets/social_media_signin_button.dart';
import 'package:synovia_ai_telehealth_app/utils/svg_assets.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  var isObsecured;

  @override
  void initState() {
    super.initState();
    isObsecured = false;
  }

  @override
  Widget build(BuildContext context) {
    // variables
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth / 600;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: darkBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // logo
              SvgPicture.asset(SvgAssets.logo_mark),

              // title
              Text(
                'Sign In',
                style: GoogleFonts.nunito(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 55 * fontSize,
                ),
              ),

              // subtitle
              Text(
                'Welcome back! Lets Continue your journey to better health.',
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

              // sign in button
              CtaButton(
                text: 'Sign in',
                svgAssets: SvgAssets.solid_arrow_right_sm,
                onTap: null,
              ),

              // Row -> Facebook, Google, Instagram
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SocialMediaSigninButton(svgAssets: SvgAssets.facebook),

                    SocialMediaSigninButton(svgAssets: SvgAssets.google),

                    SocialMediaSigninButton(svgAssets: SvgAssets.insta),
                  ],
                ),
              ),

              // Row -> Dont have an account? Sign up
              Column(
                children: [
                  SizedBox(
                    width: screenWidth,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Dont have an Account? \t\t',
                          style: GoogleFonts.nunito(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 25 * fontSize,
                          ),
                        ),

                        InkWell(
                          onTap: () {
                            Navigator.push(context, pageRoute(SignUpPage()));
                          },
                          child: Text(
                            'Sign Up.',
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

                  SizedBox(height: 10),

                  InkWell(
                    onTap: () {
                      Navigator.push(context, pageRoute(ForgotPasswordPage()));
                    },
                    child: Text(
                      'Forgot your Password?',
                      style: GoogleFonts.nunito(
                        color: brandColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 25 * fontSize,
                      ),
                    ),
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
