import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:synovia_ai_telehealth_app/config/routes.dart';
import 'package:synovia_ai_telehealth_app/core/colors.dart';
import 'package:synovia_ai_telehealth_app/features/auth/presentation/screens/sign_in_page.dart';
import 'package:synovia_ai_telehealth_app/features/auth/presentation/widgets/cta_button.dart';
import 'package:synovia_ai_telehealth_app/features/auth/presentation/widgets/forgot_methods.dart';
import 'package:synovia_ai_telehealth_app/features/onboarding_screen/presentation/widgets/custom_back_button.dart';
import 'package:synovia_ai_telehealth_app/utils/svg_assets.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth / 600;
    return Scaffold(
      backgroundColor: darkBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomBackButton(
                onTap: () {
                  Navigator.push(context, pageRoute(SignInPage()));
                },
              ),

              SizedBox(height: screenWidth * 0.08),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    'Forgot Password',
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.nunito(
                      color: Colors.white,
                      fontSize: 50 * fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 6),
                  // subtitle
                  Text(
                    'Select which methods you would like to reset.',
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.nunito(
                      color: lightTextColor,
                      fontSize: 25 * fontSize,
                    ),
                  ),
                ],
              ),

              SizedBox(height: screenWidth * 0.1),

              // options
              // email options
              ForgotMethods(
                primaryText: 'Email Address',
                secondaryText: 'Send Via email address Securely.',
                svgAssets: SvgAssets.solid_email,
              ),

              SizedBox(height: 10),

              // 2 fac auth
              ForgotMethods(
                primaryText: '2 Factor Authentication',
                secondaryText: 'Send via 2FA securely.',
                svgAssets: SvgAssets.solid_mobile,
              ),

              SizedBox(height: 10),

              // google auth
              ForgotMethods(
                primaryText: 'Google Authenticator',
                secondaryText: 'Send via authenticator securely.',
                svgAssets: SvgAssets.solid_lock,
              ),

              SizedBox(height: screenWidth * 0.09),

              // CTA
              Center(
                child: CtaButton(
                  text: 'Reset Password',
                  svgAssets: SvgAssets.solid_arrow_right_sm,
                  onTap: null,
                ),
              ),
              Spacer(),
              // lock svg
              Stack(
                children: [
                  //
                  // SvgPicture.asset(SvgAssets.lock),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
