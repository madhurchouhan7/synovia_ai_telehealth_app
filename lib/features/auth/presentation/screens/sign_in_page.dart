import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:synovia_ai_telehealth_app/core/colors.dart';
import 'package:synovia_ai_telehealth_app/features/auth/presentation/widgets/social_media_signin_button.dart';
import 'package:synovia_ai_telehealth_app/utils/svg_assets.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    // variables
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth / 600;

    return Scaffold(
      backgroundColor: darkBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // logo
              SvgPicture.asset(SvgAssets.logo_mark),

              SizedBox(height: screenWidth * 0.07),

              // title
              Text(
                'Sign In',
                style: GoogleFonts.nunito(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 50 * fontSize,
                ),
              ),
              SizedBox(height: screenWidth * 0.02),

              // subtitle
              Text(
                'Welcome back! Lets Continue your journey to better health.',
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  color: lightTextColor,

                  fontSize: 25 * fontSize,
                ),
              ),

              // email field

              // password field

              // sign in button
              InkWell(
                // onTap: () {
                //   Navigator.push(context, pageRoute(OnBoardingScreen()));
                // },
                splashColor: darkBackgroundColor,
                highlightColor: darkBackgroundColor,
                child: Container(
                  decoration: BoxDecoration(
                    color: brandColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  width: screenWidth - 80,
                  height: screenWidth * 0.15,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // text
                        Text(
                          'Sign In \t\t',
                          style: GoogleFonts.nunito(
                            fontSize: 28 * fontSize,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        // icon
                        SvgPicture.asset(
                          SvgAssets.solid_arrow_right_sm,
                          color: Colors.black,
                          height: 40 * fontSize,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: screenWidth * 0.1),

              // Row -> Facebook, Google, Instagram
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SocialMediaSigninButton(svgAssets: SvgAssets.facebook),

                  SocialMediaSigninButton(svgAssets: SvgAssets.google),

                  SocialMediaSigninButton(svgAssets: SvgAssets.insta),
                ],
              ),

              // Row -> Dont have an account? Sign up

              // forgot password
            ],
          ),
        ),
      ),
    );
  }
}
