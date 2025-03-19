import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:synovia_ai_telehealth_app/config/routes.dart';
import 'package:synovia_ai_telehealth_app/core/colors.dart';
import 'package:synovia_ai_telehealth_app/features/auth/presentation/screens/sign_in_page.dart';
import 'package:synovia_ai_telehealth_app/features/onboarding_screen/presentation/widgets/custom_back_button.dart';
import 'package:synovia_ai_telehealth_app/features/onboarding_screen/presentation/widgets/custom_onboarding_button.dart';
import 'package:synovia_ai_telehealth_app/features/onboarding_screen/presentation/widgets/onboarding_content.dart';
import 'package:synovia_ai_telehealth_app/utils/svg_assets.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  // Controller instance
  final _controller = OnboardingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: darkBackgroundColor,
        body: ValueListenableBuilder(
          valueListenable: _controller.currentPageNotifier,
          builder: (context, value, child) {
            return PageView.builder(
              controller: _controller.pageController,
              itemCount: _controller.contents.length,
              onPageChanged: (index) {
                setState(() {
                  _controller.onPageChanged(index);
                });
              },
              itemBuilder: (context, index) {
                final content = _controller.contents[index];
                return _buildOnboardingPage(context, content);
              },
            );
          },
        ),
      ),
    );
  }

  /// Builds a single onboarding page
  Widget _buildOnboardingPage(BuildContext context, OnboardingContent content) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth / 600;

    return SizedBox.expand(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Top section with image and navigation bar
          _buildTopSection(screenWidth),

          // Content section with title and subtitle
          _buildContentSection(content, fontSize),

          // Bottom navigation buttons
          _buildNavigationButtons(),

          const SizedBox(height: 10),
        ],
      ),
    );
  }

  /// Builds the top section with SVG image and navigation bar
  Widget _buildTopSection(double screenWidth) {
    return Stack(
      children: [
        // Background image
        SvgPicture.asset(
          _controller.currentContent.svgAssets,
          width: screenWidth,
        ),

        // Top bar
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back button
              CustomBackButton(onTap: _controller.toFirstPage),

              // Progress indicator
              SizedBox(
                width: screenWidth * 0.45,
                child: LinearProgressBar(
                  maxSteps: _controller.contents.length,
                  currentStep: _controller.currentPage + 1,
                  borderRadius: BorderRadius.circular(15),
                  progressColor: Colors.white,
                  backgroundColor: const Color(0x50FFFFFF),
                ),
              ),

              // Skip button
              InkWell(
                onTap: _controller.skipToEnd,
                child: Text(
                  'Skip',
                  style: GoogleFonts.nunito(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Builds the content section with title and subtitle
  Widget _buildContentSection(OnboardingContent content, double fontSize) {
    return Column(
      children: [
        // Title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            content.title,
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
              color: Colors.white,
              fontSize: 48 * fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(height: 10),

        // Subtitle
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            content.subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
              color: lightTextColor,
              fontSize: 25 * fontSize,
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the navigation buttons at the bottom
  Widget _buildNavigationButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Previous button
        CustomOnboardingButton(
          onTap: _controller.isFirstPage ? null : _controller.previousPage,
          svgAssets: SvgAssets.solid_arrow_left_sm,
        ),

        // Next button
        CustomOnboardingButton(
          onTap: () {
            if (_controller.isLastPage) {
              Navigator.pushReplacement(context, pageRoute(SignInPage()));
            } else {
              _controller.nextPage();
            }
          },
          svgAssets: SvgAssets.solid_arrow_right_sm,
        ),
      ],
    );
  }
}
