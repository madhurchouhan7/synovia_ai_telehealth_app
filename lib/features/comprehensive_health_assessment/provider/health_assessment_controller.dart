import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:synovia_ai_telehealth_app/features/comprehensive_health_assessment/data/gender_option.dart';
import 'package:synovia_ai_telehealth_app/features/comprehensive_health_assessment/data/user_health_model.dart';
import 'package:synovia_ai_telehealth_app/features/comprehensive_health_assessment/repo/health_assessment_repo.dart';
import 'package:synovia_ai_telehealth_app/utils/svg_assets.dart';

class HealthAssessmentController extends ChangeNotifier {
  final HealthAssessmentRepo _healthAssessmentRepo = HealthAssessmentRepo();
  UserHealthModel _userHealthModel = UserHealthModel();
  int _currentPageIndex = 0;
  UserHealthModel get userHealthModel => _userHealthModel;
  int get currentPageIndex => _currentPageIndex;

  // method for ui to update data
  void updateAge(int age) {
    _userHealthModel.age = age;
    notifyListeners();
  }
  String? selectedGoal;

  void updateGoal(String? goal) {
    selectedGoal = goal;
    notifyListeners();
  }

  void updateWeight(double weight) {
    _userHealthModel.weight = weight;
    notifyListeners();
  }


  void updateGender(String gender) {
    _userHealthModel.gender = gender;
    notifyListeners();
  }

  // Methods for UI to navigate
  void goToNextPage(PageController pageController) {
    if (_currentPageIndex < 14) {
      _currentPageIndex++;
      pageController.animateToPage(
        _currentPageIndex,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
      notifyListeners();
    }
  }

  void goToPreviousPage(PageController pageController) {
    if (_currentPageIndex > 0) {
      _currentPageIndex--;
      pageController.animateToPage(
        _currentPageIndex,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
      notifyListeners();
    }
  }

  // Add this method to convert userHealthModel to a Map
  Map<String, dynamic> toMap() {
    return {
      'goal': _userHealthModel.goal,
      'gender': _userHealthModel.gender,
      'age': _userHealthModel.age,
      'weight': _userHealthModel.weight,
      'height': _userHealthModel.height,
      'bloodType': _userHealthModel.bloodType,
      'fitnessLevel': _userHealthModel.fitnessLevel,
      'medicalConditions': _userHealthModel.medicalConditions,
      'medication': _userHealthModel.medication,
      'alcoholConsumption': _userHealthModel.alcoholConsumption,
      'allergies': _userHealthModel.allergies,
      'sleepHours': _userHealthModel.sleepHours,
      // Add more fields as needed
    };
  }

  Future<void> submitAssessment(String uid) async {
    try {
      // Save to Firestore
      await FirebaseFirestore.instance
          .collection('user_health_assessments')
          .doc(uid)
          .set(toMap());
      // Optionally, also call your repo if needed
      // await _healthAssessmentRepo.saveHeathProfile(uid, _userHealthModel);
    } catch (e) {
      print('Error submitting health assessment: $e');
      // Optionally handle error (show snackbar, etc.)
    }
  }

  final List<GenderOption> genderOptions = [
    GenderOption(
      label: 'I am Male',
      value: 'Male',
      iconPath: SvgAssets.ic_gender_male,
      selectedBackgroundColor: Colors.lightGreen.shade200,
      selectedIconColor: const Color(0xFF6B7E48),
      unselectedBackgroundColor: Colors.grey.shade700,
      unselectedIconColor: Colors.grey.shade400,
    ),
    GenderOption(
      label: 'I am Female',
      value: 'Female',
      iconPath: SvgAssets.ic_gender_female,
      selectedBackgroundColor: Colors.pink.shade200,
      selectedIconColor: const Color(0xFF9E3F5F),
      unselectedBackgroundColor: Colors.grey.shade700,
      unselectedIconColor: Colors.grey.shade400,
    ),
  ];
  String? _selectedGenderValue;

  String? get selectedGenderValue => _selectedGenderValue;

  void setSelectedGender(String? genderValue) {
    _selectedGenderValue = genderValue;
    userHealthModel.gender = genderValue; // Update your data model
    notifyListeners(); // Notify listeners that the selected gender has changed
  }
}
