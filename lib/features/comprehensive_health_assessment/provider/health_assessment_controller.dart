
import 'package:flutter/widgets.dart';

class HealthAssessmentController extends ChangeNotifier {
  final PageController pageController = PageController();
  int _currentIndex = 0;
  int get currentPage => _currentIndex;

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners(); // Notify UI about the change
  }

  void nextPage() {
    if (_currentIndex < 4) {
      _currentIndex++;
      pageController.animateToPage(
        _currentIndex,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      notifyListeners();
    }
  }

  void previousPage() {
    if (_currentIndex > 0) {
      _currentIndex--;
      pageController.animateToPage(
        _currentIndex,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      notifyListeners();
    }
  }

  void skipToLast() {
    _currentIndex = 4;
    pageController.jumpToPage(_currentIndex);
    notifyListeners();
  }
}
