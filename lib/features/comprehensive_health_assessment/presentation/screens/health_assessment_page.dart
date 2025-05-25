import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:synovia_ai_telehealth_app/core/colors.dart';
import 'package:synovia_ai_telehealth_app/features/auth/presentation/widgets/cta_button.dart';
import 'package:synovia_ai_telehealth_app/features/comprehensive_health_assessment/presentation/widgets/health_assessment_content.dart';
import 'package:synovia_ai_telehealth_app/features/onboarding_screen/presentation/widgets/custom_back_button.dart';
import 'package:synovia_ai_telehealth_app/utils/svg_assets.dart';

class HealthAssessmentPage extends StatefulWidget {
  const HealthAssessmentPage({super.key});

  @override
  State<HealthAssessmentPage> createState() => _HealthAssessmentPageState();
}

class _HealthAssessmentPageState extends State<HealthAssessmentPage> {
  final _controller = HealthAssessmentController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // final screenWidth = MediaQuery.of(context).size.width;
    // final fontSize = screenWidth / 600;

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
                return _buildHealthAssessmentPage(context, content);
              },
            );
          },
        ),
      ),
    );
  }

  /// Builds a single onboarding page
  Widget _buildHealthAssessmentPage(
    BuildContext context,
    HealthAssessmentContent content,
  ) {
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
        // SvgPicture.asset(

        //   width: screenWidth,
        // ),

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
                  progressColor: brandColor,
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
  Widget _buildContentSection(
    HealthAssessmentContent content,
    double fontSize,
  ) {
    return Column(
      children: [
        // Title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            content.title,
            overflow: TextOverflow.clip,
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
              color: Colors.white,
              fontSize: 40 * fontSize,
              fontWeight: FontWeight.w900,
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
    return CtaButton(
      text: 'Continue',
      svgAssets: SvgAssets.solid_arrow_right_sm,
      onTap: null,
    );
  }
}
