import 'package:flutter/material.dart';
import 'package:synovia_ai_telehealth_app/utils/svg_assets.dart';

/// Data model for onboarding content
class OnboardingContent {
  final String svgAssets;
  final String title;
  final String subtitle;

  OnboardingContent({
    required this.title,
    required this.subtitle,
    required this.svgAssets,
  });
}

/// Controller class that handles all business logic
class OnboardingController {
  /// The page controller used for the PageView
  final PageController pageController = PageController();

  // Use ValueNotifier to update UI when page changes
  final ValueNotifier<int> currentPageNotifier = ValueNotifier<int>(0);

  /// Track the current page index
  int currentPage = 0;

  /// Getter to check if we're on the first page
  bool get isFirstPage => currentPage == 0;

  /// Getter to check if we're on the last page
  bool get isLastPage => currentPage == contents.length - 1;

  /// All onboarding content pages
  final List<OnboardingContent> contents = [
    OnboardingContent(
      title: "Smart Appointment Scheduling",
      subtitle: "Experience the Power of Scheduling",
      svgAssets: SvgAssets.doctor_onboarding,
    ),
    OnboardingContent(
      title: "Intelligent Wellness AI ChatBot for All",
      subtitle: "Wellness AI Chatbot at your fingertips.",
      svgAssets: SvgAssets.robot_onboarding,
    ),
    OnboardingContent(
      title: "AI-Powered Symptoms Analysis, Made Easy",
      subtitle: "AI-Powered Symptoms Analysis, Made Easy",
      svgAssets: SvgAssets.ai_onboarding,
    ),
    OnboardingContent(
      title: "AI-Driven Virtual Consultation",
      subtitle: "Say Goodbye to old digital Consultations",
      svgAssets: SvgAssets.health_assessment_onboarding,
    ),
    OnboardingContent(
      title: "EHR Access at your Fingertips, anywhere",
      subtitle: "Empower your health data anywhere",
      svgAssets: SvgAssets.report_onboarding,
    ),
  ];

  /// Get the current content based on page index
  OnboardingContent get currentContent => contents[currentPage];

  /// Navigate to the next page
  void nextPage() {
    if (!isLastPage) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // TODO: Navigate to home/login screen
      print('Onboarding complete');
    }
  }

  /// Navigate to the previous page
  void previousPage() {
    if (!isFirstPage) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /// Skip to the end of onboarding
  void skipToEnd() {
    pageController.animateToPage(
      contents.length - 1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  /// Go to the first Page
  void toFirstPage() {
    pageController.animateToPage(
      currentPage = 0,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  /// Update current page index
  void onPageChanged(int index) {
    currentPage = index;
  }
}
