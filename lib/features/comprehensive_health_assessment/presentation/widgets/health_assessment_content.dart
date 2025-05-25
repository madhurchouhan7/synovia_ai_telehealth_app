import 'package:flutter/widgets.dart';

class HealthAssessmentContent {
  final String title;
  final String subtitle;
  final Widget mainContent;

  HealthAssessmentContent({
    required this.title,
    required this.subtitle,
    required this.mainContent,
  });
}

class HealthAssessmentController {
  final PageController pageController = PageController();
  final ValueNotifier<int> currentPageNotifier = ValueNotifier<int>(0);
  int currentPage = 0;

  bool get isFirstPage => currentPage == 0;
  bool get isLastPage => currentPage == contents.length - 1;

  final List<HealthAssessmentContent> contents = [
    // select your goal
    HealthAssessmentContent(
      title: "Select Your Goal",
      subtitle: "Choose your health goal.",
      mainContent: const Text("List here various goals in form of list"),
    ),

    // select your gender
    HealthAssessmentContent(
      title: "Select Your Gender",
      subtitle: "",
      mainContent: const Text(
        "List here 2 options, male and female. then with cta create option prefer not to say",
      ),
    ),

    // select your age
    HealthAssessmentContent(
      title: "Whats your age?",
      subtitle: "0",
      mainContent: const Text("create a slider to select age"),
    ),

    // select your weight
    HealthAssessmentContent(
      title: "Whats your current weight right now?",
      subtitle: "Choose in Kilograms",
      mainContent: const Text("create a slider to select weight"),
    ),

    // blood type

    // fitness level

    // medical condition

    // Medication

    // Alcohol use

    // select your goal

    // allergies

    // whats your mood

    // sleep level

    // AI Health Insights disclaimer
  ];

  HealthAssessmentContent get currentContent => contents[currentPage];

  void nextPage() {
    if (!isLastPage) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
    
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
