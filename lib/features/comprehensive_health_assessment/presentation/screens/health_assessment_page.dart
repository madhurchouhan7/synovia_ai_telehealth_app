import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:numeric_selector/numeric_selector.dart';
import 'package:provider/provider.dart';
import 'package:synovia_ai_telehealth_app/config/routes.dart';
import 'package:synovia_ai_telehealth_app/core/colors.dart';
import 'package:synovia_ai_telehealth_app/features/auth/presentation/widgets/cta_button.dart';
import 'package:synovia_ai_telehealth_app/features/comprehensive_health_assessment/presentation/widgets/blood_type_card.dart';
import 'package:synovia_ai_telehealth_app/features/comprehensive_health_assessment/presentation/widgets/gender_selection_card.dart';
import 'package:synovia_ai_telehealth_app/features/comprehensive_health_assessment/presentation/widgets/select_your_goal_widget.dart';
import 'package:synovia_ai_telehealth_app/features/comprehensive_health_assessment/provider/health_assessment_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:synovia_ai_telehealth_app/features/home/home_page.dart';
import 'package:synovia_ai_telehealth_app/utils/svg_assets.dart';

class HealthAssessmentPage extends StatefulWidget {
  const HealthAssessmentPage({super.key});

  @override
  State<HealthAssessmentPage> createState() => _HealthAssessmentPageState();
}

class _HealthAssessmentPageState extends State<HealthAssessmentPage> {
  late final PageController _pageController;
  late final HealthAssessmentController _healthAssessmentController;

  // Form fields
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _sleepController = TextEditingController();
  String? _selectedGoal;
  String? _selectedGender;
  String? _selectedBloodType;
  String? _selectedFitnessLevel;
  String? _selectedAlcohol;
  String? _selectedSmoking;
  String? _selectedAllergies;
  bool? _medicalConditions;
  String? _specifyMedication;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _healthAssessmentController = HealthAssessmentController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _healthAssessmentController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _sleepController.dispose();
    super.dispose();
  }

  void _saveAndNext(VoidCallback updateModel) {
    updateModel();
    _healthAssessmentController.goToNextPage(_pageController);
  }

  Future<void> _submitAssessment() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _healthAssessmentController.submitAssessment(user.uid);
      if (mounted) {
        Navigator.of(
          context,
        ).pushAndRemoveUntil(pageRoute(HomePage()), (route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth / 600;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: darkBackgroundColor,
        body: AnimatedBuilder(
          animation: _healthAssessmentController,
          builder: (context, child) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Column(
                children: [
                  SizedBox(
                    width: screenWidth * 0.8,
                    child: LinearProgressBar(
                      maxSteps: 12,
                      currentStep:
                          _healthAssessmentController.currentPageIndex + 1,
                      borderRadius: BorderRadius.circular(15),
                      progressColor: brandColor,
                      backgroundColor: const Color(0x50FFFFFF),
                    ),
                  ),
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        // 1.  select your goal
                        _buildQuestionPage(
                          title: 'Select your Goal',
                          child: Column(
                            children: [
                              // 1 -> plus
                              SelectYourGoalWidget(
                                text: 'I want AI symptoms checker',
                                iconPath: SvgAssets.ic_health_plus,
                                iconColor: brandColor,
                                iconBackgroundColor: Color(0xFF365314),
                              ),

                              // 2 -> weight scale
                              SelectYourGoalWidget(
                                text: 'I want quick Doctor booking',
                                iconPath: SvgAssets.ic_weight_scale,
                                iconColor: Colors.blue.shade200,
                                iconBackgroundColor: Color(0xFF1E3A8A),
                              ),

                              // 3 -> skull love
                              SelectYourGoalWidget(
                                text: 'I want Wellness AI Chatbot',
                                iconPath: SvgAssets.ic_head_heart,
                                iconColor: const Color.fromARGB(
                                  255,
                                  151,
                                  129,
                                  211,
                                ),
                                iconBackgroundColor: Colors.deepPurple.shade800,
                              ),

                              // 4 ->medicine
                              SelectYourGoalWidget(
                                text: 'I want intuitive medication \nmanager',
                                iconPath: SvgAssets.ic_pill,
                                iconColor: Colors.grey,
                                iconBackgroundColor: Colors.grey.shade800,
                              ),

                              // 5 -> mobile
                              SelectYourGoalWidget(
                                text: 'Just Trying out the app!',
                                iconPath: SvgAssets.ic_mobile,
                                iconColor: Colors.yellow,
                                iconBackgroundColor: Colors.yellow.shade900,
                              ),
                            ],
                          ),
                          onNext: () {
                            // Set the goal directly in the model (use a value, or let user select)
                            // Example: set to a default or selected value
                            _healthAssessmentController.userHealthModel.goal =
                                "I want AI symptoms checker";
                            _saveAndNext(() {});
                          },
                        ),

                        // 2. select gender
                        _buildQuestionPage(
                          title: "Select your Gender",
                          child: Consumer<HealthAssessmentController>(
                            builder: (context, controller, child) {
                              return Column(
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    height:
                                        MediaQuery.of(context).size.width * 0.5,
                                    child: PageView.builder(
                                      controller: PageController(),
                                      scrollDirection: Axis.horizontal,
                                      itemCount:
                                          controller.genderOptions.length,
                                      itemBuilder: (context, index) {
                                        final option =
                                            controller.genderOptions[index];
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 7.0,
                                          ),
                                          child: GenderSelectionCard(
                                            option: option,
                                            isSelected:
                                                controller
                                                    .selectedGenderValue ==
                                                option.value,
                                            onTap: () {
                                              controller.setSelectedGender(
                                                option.value,
                                              );
                                              // Remove setState and local _selectedGender, rely only on controller
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              );
                            },
                          ),
                          onNext: () {
                            final selected =
                                _healthAssessmentController
                                    .selectedGenderValue ??
                                Provider.of<HealthAssessmentController>(
                                  context,
                                  listen: false,
                                ).selectedGenderValue;
                            if (selected != null && selected.isNotEmpty) {
                              _healthAssessmentController
                                  .userHealthModel
                                  .gender = selected;
                              _healthAssessmentController.updateGender(
                                selected,
                              );
                              _saveAndNext(() {});
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Please select a gender before continuing.',
                                  ),
                                ),
                              );
                            }
                          },
                          showBack: true,
                          onBack: () {
                            Provider.of<HealthAssessmentController>(
                              context,
                              listen: false,
                            ).goToPreviousPage(_pageController);
                          },
                        ),

                        // 3.  whats your age
                        _buildQuestionPage(
                          title: "What's your age?",
                          child: VerticalNumericSelector(
                            minValue: 0,
                            maxValue: 100,
                            step: 1,
                            initialValue: 18,
                            onValueChanged: (value) {
                              _ageController.text = value.toString();
                              _healthAssessmentController.userHealthModel.age =
                                  value;
                            },
                            viewPort: 0.3,
                            label: 'Years',
                            backgroundColor: secondaryColor,
                            showArrows: true,
                            selectedTextStyle: GoogleFonts.nunito(
                              color: Colors.white,
                              fontSize: fontSize * 50,
                              fontWeight: FontWeight.w700,
                            ),
                            showLabel: true,
                            enableVibration: true,
                          ),
                          onNext:
                              () => _saveAndNext(() {
                                final age =
                                    int.tryParse(_ageController.text) ?? 0;
                                _healthAssessmentController
                                    .userHealthModel
                                    .age = age;
                              }),
                        ),
                        // 4. current weight
                        _buildQuestionPage(
                          title: "What's your current weight right now?",
                          child: HorizontalNumericSelector(
                            minValue: 0,
                            maxValue: 150,
                            step: 1,
                            initialValue: 60,
                            onValueChanged: (value) {
                              _weightController.text = value.toString();
                              _healthAssessmentController
                                  .userHealthModel
                                  .weight = value.toDouble();
                            },
                            viewPort: 0.2,
                            label: 'Kg',
                            backgroundColor: secondaryColor,
                            showArrows: true,
                            selectedTextStyle: GoogleFonts.nunito(
                              color: Colors.white,
                              fontSize: fontSize * 50,
                              fontWeight: FontWeight.w700,
                            ),
                            showLabel: true,
                            enableVibration: true,
                          ),
                          onNext:
                              () => _saveAndNext(() {
                                final weight =
                                    double.tryParse(_weightController.text) ??
                                    0.0;
                                _healthAssessmentController
                                    .userHealthModel
                                    .weight = weight;
                              }),
                        ),
                        // 5. current height
                        _buildQuestionPage(
                          title: "What's your current height?",
                          child: HorizontalNumericSelector(
                            minValue: 0,
                            maxValue: 250,
                            step: 1,
                            initialValue: 170,
                            onValueChanged: (value) {
                              _heightController.text = value.toString();
                              _healthAssessmentController
                                  .userHealthModel
                                  .height = value.toDouble();
                            },
                            viewPort: 0.2,
                            label: 'cm',
                            backgroundColor: secondaryColor,
                            showArrows: true,
                            selectedTextStyle: GoogleFonts.nunito(
                              color: Colors.white,
                              fontSize: fontSize * 50,
                              fontWeight: FontWeight.w700,
                            ),
                            showLabel: true,
                            enableVibration: true,
                          ),
                          onNext:
                              () => _saveAndNext(() {
                                final height =
                                    double.tryParse(_heightController.text) ??
                                    0.0;
                                _healthAssessmentController
                                    .userHealthModel
                                    .height = height;
                              }),
                        ),
                        // 6. Blood Type
                        _buildQuestionPage(
                          title: "What's your blood type?",
                          child: Column(
                            children: [
                              BloodTypeCard(
                                selectedBloodType: _selectedBloodType,
                                onSelected: (type) {
                                  setState(() {
                                    _selectedBloodType = type;
                                    _healthAssessmentController
                                        .userHealthModel
                                        .bloodType = type;
                                  });
                                },
                              ),
                              if (_selectedBloodType != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: Text(
                                    _selectedBloodType!,
                                    style: GoogleFonts.nunito(
                                      fontSize: 200 * fontSize,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          onNext:
                              () => _saveAndNext(() {
                                _healthAssessmentController
                                    .userHealthModel
                                    .bloodType = _selectedBloodType;
                              }),
                        ),

                        // 7. Fitness Level
                        _buildQuestionPage(
                          title: "Fitness Level",
                          child: Column(
                            children: [
                              Text(
                                'How frequently do you exercise?',
                                style: GoogleFonts.nunito(
                                  color: lightTextColor,
                                  fontSize: fontSize * 28,
                                ),
                              ),

                              const SizedBox(height: 16),

                              SvgPicture.asset(SvgAssets.frame),

                              // slider for fitness level
                              DropdownButton(
                                dropdownColor: secondaryColor,
                                hint: Text(
                                  'Select Fitness Level',
                                  style: GoogleFonts.nunito(),
                                ),
                                items: [
                                  DropdownMenuItem(
                                    value: 'Sedentary',
                                    child: Text('Sedentary'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Lightly Active',
                                    child: Text('Lightly Active'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Moderately Active',
                                    child: Text('Moderately Active'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Very Active',
                                    child: Text('Very Active'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Super Active',
                                    child: Text('Super Active'),
                                  ),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _selectedFitnessLevel = value;
                                    _healthAssessmentController
                                        .userHealthModel
                                        .fitnessLevel = value;
                                  });
                                },
                                value: _selectedFitnessLevel,
                              ),
                            ],
                          ),
                          onNext:
                              () => _saveAndNext(() {
                                _healthAssessmentController
                                    .userHealthModel
                                    .fitnessLevel = _selectedFitnessLevel;
                              }),
                        ),

                        // 8. Medical Conditions
                        _buildQuestionPage(
                          title: "Medical Conditions",
                          child: Column(
                            children: [
                              Text(
                                textAlign: TextAlign.center,
                                'Please list all the previous medical conditions you have:',
                                style: GoogleFonts.nunito(
                                  color: lightTextColor,
                                  fontSize: fontSize * 28,
                                ),
                              ),
                              const SizedBox(height: 16),
                              SvgPicture.asset(SvgAssets.patient),
                              SwitchListTile(
                                activeColor: brandColor,
                                inactiveTrackColor: secondaryColor,

                                title: Text(
                                  'Yes',
                                  style: GoogleFonts.nunito(
                                    color: Colors.white,
                                    fontSize: fontSize * 24,
                                  ),
                                ),
                                value: _medicalConditions ?? false,
                                onChanged: (value) {
                                  setState(() {
                                    _medicalConditions = value;
                                  });
                                },
                              ),

                              SizedBox(height: 16),

                              if (_medicalConditions == true)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      labelText: 'Specify Medication',
                                      labelStyle: GoogleFonts.nunito(
                                        color: lightTextColor,
                                      ),
                                      filled: true,
                                      fillColor: secondaryColor,
                                    ),
                                    onChanged: (value) {
                                      _specifyMedication = value;
                                    },
                                  ),
                                ),
                            ],
                          ),
                          onNext:
                              () => _saveAndNext(() {
                                _healthAssessmentController
                                        .userHealthModel
                                        .medicalConditions =
                                    _medicalConditions ?? false;
                              }),
                        ),

                        // 9. medication
                        _buildQuestionPage(
                          title: "Medications",
                          child: Column(
                            children: [
                              Text(
                                textAlign: TextAlign.center,
                                'Please list all the medications you are currently taking:',
                                style: GoogleFonts.nunito(
                                  color: lightTextColor,
                                  fontSize: fontSize * 28,
                                ),
                              ),
                              const SizedBox(height: 16),
                              SvgPicture.asset(SvgAssets.pills),
                              SwitchListTile(
                                activeColor: brandColor,
                                inactiveTrackColor: secondaryColor,
                                title: Text(
                                  'Yes',
                                  style: GoogleFonts.nunito(
                                    color: Colors.white,
                                    fontSize: fontSize * 24,
                                  ),
                                ),
                                value: _medicalConditions ?? false,
                                onChanged: (value) {
                                  setState(() {
                                    _medicalConditions = value;
                                  });
                                },
                              ),

                              SizedBox(height: 16),

                              if (_medicalConditions == true)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      labelText:
                                          'Specify Medication (optional)',
                                      labelStyle: GoogleFonts.nunito(
                                        color: lightTextColor,
                                      ),
                                      filled: true,
                                      fillColor: secondaryColor,
                                    ),
                                    onChanged: (value) {
                                      _specifyMedication = value;
                                    },
                                  ),
                                ),
                            ],
                          ),
                          onNext:
                              () => _saveAndNext(() {
                                _healthAssessmentController
                                    .userHealthModel
                                    .medication = _medicalConditions ?? false;
                              }),
                        ),

                        // 10. alcohol usage
                        _buildQuestionPage(
                          title: "Alcohol Usage",
                          child: Column(
                            children: [
                              Text(
                                textAlign: TextAlign.center,
                                'How often do you consume alcohol?',
                                style: GoogleFonts.nunito(
                                  color: lightTextColor,
                                  fontSize: fontSize * 28,
                                ),
                              ),
                              const SizedBox(height: 16),
                              SvgPicture.asset(SvgAssets.alcohol_bottle),
                              SwitchListTile(
                                activeColor: brandColor,
                                inactiveTrackColor: secondaryColor,
                                title: Text(
                                  'Yes',
                                  style: GoogleFonts.nunito(
                                    color: Colors.white,
                                    fontSize: fontSize * 24,
                                  ),
                                ),
                                value: _selectedAlcohol == 'Yes',
                                onChanged: (value) {
                                  setState(() {
                                    _selectedAlcohol = value ? 'Yes' : 'No';
                                  });
                                },
                              ),

                              SizedBox(height: 16),

                              if (_selectedAlcohol == 'Yes')
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      labelText:
                                          'Specify Alcohol Consumption (optional)',
                                      labelStyle: GoogleFonts.nunito(
                                        color: lightTextColor,
                                      ),
                                      filled: true,
                                      fillColor: secondaryColor,
                                    ),
                                    onChanged: (value) {
                                      _selectedAlcohol = value;
                                    },
                                  ),
                                ),
                            ],
                          ),
                          onNext:
                              () => _saveAndNext(() {
                                _healthAssessmentController
                                    .userHealthModel
                                    .alcoholConsumption = _selectedAlcohol;
                              }),
                        ),

                        // 11. allergies
                        _buildQuestionPage(
                          title: "Allergies",
                          child: Column(
                            children: [
                              Text(
                                textAlign: TextAlign.center,
                                'Do you have any ongoing allergies?',
                                style: GoogleFonts.nunito(
                                  color: lightTextColor,
                                  fontSize: fontSize * 28,
                                ),
                              ),
                              const SizedBox(height: 16),
                              SvgPicture.asset(SvgAssets.allergies),
                              SwitchListTile(
                                activeColor: brandColor,
                                inactiveTrackColor: secondaryColor,
                                title: Text(
                                  'Yes',
                                  style: GoogleFonts.nunito(
                                    color: Colors.white,
                                    fontSize: fontSize * 24,
                                  ),
                                ),
                                value: _selectedAllergies == 'Yes',
                                onChanged: (value) {
                                  setState(() {
                                    _selectedAllergies = value ? 'Yes' : 'No';
                                  });
                                },
                              ),

                              SizedBox(height: 16),

                              if (_selectedAllergies == 'Yes')
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      labelText: 'Specify Allergies (optional)',
                                      labelStyle: GoogleFonts.nunito(
                                        color: lightTextColor,
                                      ),
                                      filled: true,
                                      fillColor: secondaryColor,
                                    ),
                                    onChanged: (value) {
                                      _selectedAllergies = value;
                                    },
                                  ),
                                ),
                            ],
                          ),
                          onNext:
                              () => _saveAndNext(() {
                                _healthAssessmentController
                                    .userHealthModel
                                    .allergies = _selectedAllergies;
                              }),
                        ),

                        // 12. sleep level
                        _buildQuestionPage(
                          title: "Sleep Level",
                          child: Column(
                            children: [
                              Text(
                                textAlign: TextAlign.center,
                                'How many hours do you \nsleep on average?',
                                style: GoogleFonts.nunito(
                                  color: lightTextColor,
                                  fontSize: fontSize * 30,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 16),

                              Text(
                                textAlign: TextAlign.center,
                                'Moderate Sleep Hours\n(7-9 hours)',
                                style: GoogleFonts.nunito(
                                  color: lightTextColor,
                                  fontSize: fontSize * 24,
                                ),
                              ),
                              const SizedBox(height: 16),

                              HorizontalNumericSelector(
                                minValue: 0,
                                maxValue: 24,
                                step: 1,
                                initialValue: 7,
                                onValueChanged: (value) {
                                  _sleepController.text = value.toString();
                                  _healthAssessmentController
                                      .userHealthModel
                                      .sleepHours = value.toDouble();
                                },
                                viewPort: 0.2,
                                label: 'Hours',
                                backgroundColor: secondaryColor,
                                showArrows: true,
                                selectedTextStyle: GoogleFonts.nunito(
                                  color: Colors.white,
                                  fontSize: fontSize * 50,
                                  fontWeight: FontWeight.w700,
                                ),
                                showLabel: true,
                                enableVibration: true,
                              ),
                            ],
                          ),
                          onNext: () async {
                            _saveAndNext(() {
                              final sleepHours =
                                  double.tryParse(_sleepController.text) ?? 0.0;
                              _healthAssessmentController
                                  .userHealthModel
                                  .sleepHours = sleepHours;
                            });
                            
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return const Center(
                                  child: CircularProgressIndicator(
                                    color: brandColor,
                                  ),
                                );
                              },
                            );

                            final user = FirebaseAuth.instance.currentUser;
                            if (user != null) {
                              await _healthAssessmentController
                                  .submitAssessment(user.uid);
                              if (mounted) {
                                Navigator.of(context).pushAndRemoveUntil(
                                  pageRoute(HomePage()),
                                  (route) => false,
                                );
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildQuestionPage({
    required String title,
    required Widget child,
    required VoidCallback onNext,
    bool showBack = false,
    VoidCallback? onBack,
    String nextLabel = 'Continue',
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth / 600;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
              color: Colors.white,
              fontSize: fontSize * 50,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 32),
          child,
          const SizedBox(height: 32),
          if (showBack) ElevatedButton(onPressed: onBack, child: Text("Back")),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CtaButton(
                onTap: onNext,
                text: nextLabel,
                svgAssets: SvgAssets.solid_arrow_right_sm,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
