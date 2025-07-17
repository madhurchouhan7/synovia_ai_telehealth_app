import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:synovia_ai_telehealth_app/core/colors.dart';
import 'package:synovia_ai_telehealth_app/features/symptoms_history/provider/symptoms_history_provider.dart';
import 'package:synovia_ai_telehealth_app/features/symptoms_history/widgets/symptom_card.dart';
import 'package:synovia_ai_telehealth_app/features/symptoms_history/widgets/health_insights_card.dart';
import 'package:synovia_ai_telehealth_app/features/symptoms_history/widgets/severity_filter_chip.dart';
import 'package:synovia_ai_telehealth_app/features/symptoms_history/widgets/health_insights_card_skeleton.dart'
    as skeletons;
import 'package:synovia_ai_telehealth_app/features/symptoms_history/widgets/symptom_card_skeleton.dart'
    as skeletons;
import 'package:synovia_ai_telehealth_app/features/symptoms_history/widgets/personalized_health_tips_card.dart';
import 'package:synovia_ai_telehealth_app/features/symptoms_history/models/symptom_record.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTab = 0;
  String _selectedSeverity = 'all';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _selectedTab = _tabController.index;
        });
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SymptomsHistoryProvider>().loadSymptomsHistory();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List getTodaySymptoms(SymptomsHistoryProvider provider) {
    final now = DateTime.now();
    return provider.allSymptoms.where((symptom) {
      return symptom.timestamp.year == now.year &&
          symptom.timestamp.month == now.month &&
          symptom.timestamp.day == now.day;
    }).toList();
  }

  void _showResolvedSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Symptom marked as resolved!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showNotesSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Follow-up notes added!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth / 600;

    return Scaffold(
      backgroundColor: darkBackgroundColor,
      appBar: AppBar(
        backgroundColor: Color(0xFF212C24),
        centerTitle: true,
        title: Text(
          'Health Progress',
          style: GoogleFonts.nunito(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 24,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: brandColor,
          labelColor: Colors.white,
          unselectedLabelColor: lightTextColor,
          labelStyle: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          tabs: [Tab(text: 'Today'), Tab(text: 'Week'), Tab(text: 'Month')],
          onTap: (index) {
            setState(() {
              _selectedTab = index;
            });
          },
        ),
      ),
      body: Consumer<SymptomsHistoryProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return RefreshIndicator(
              color: brandColor,
              onRefresh: () async {
                await provider.loadSymptomsHistory();
              },
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: skeletons.HealthInsightsCardSkeleton(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 36,
                              margin: EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: Colors.grey[800],
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 36,
                              margin: EdgeInsets.only(left: 8),
                              decoration: BoxDecoration(
                                color: Colors.grey[800],
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: List.generate(
                          2,
                          (index) => Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: skeletons.SymptomCardSkeleton(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 80),
                  SizedBox(height: 16),
                  Text(
                    'Error loading data',
                    style: GoogleFonts.nunito(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    provider.error!,
                    style: GoogleFonts.nunito(
                      color: lightTextColor,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.loadSymptomsHistory(),
                    child: Text(
                      'Retry',
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          // Choose the correct symptoms list based on the selected tab
          List symptomsList;
          String periodLabel;
          if (_selectedTab == 0) {
            symptomsList = getTodaySymptoms(provider);
            periodLabel = 'Today';
          } else if (_selectedTab == 1) {
            symptomsList = provider.lastWeekSymptoms;
            periodLabel = 'Last Week';
          } else {
            symptomsList = provider.lastMonthSymptoms;
            periodLabel = 'Last Month';
          }

          // Filter by severity if not 'all'
          List filteredSymptoms = symptomsList;
          if (_selectedSeverity != 'all') {
            filteredSymptoms =
                symptomsList
                    .where((symptom) => symptom.severity == _selectedSeverity)
                    .toList();
          }

          return RefreshIndicator(
            color: brandColor,
            onRefresh: () async {
              await provider.loadSymptomsHistory();
            },
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PersonalizedHealthTipsCard(
                    symptoms: symptomsList.cast<SymptomRecord>(),
                    periodLabel: periodLabel,
                  ),
                  if (provider.healthInsights.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: HealthInsightsCard(
                        insights: provider.healthInsights,
                        fontSize: fontSize,
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SeverityFilterChip(
                      selectedSeverity: _selectedSeverity,
                      onSeverityChanged: (severity) {
                        setState(() {
                          _selectedSeverity = severity;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  // Symptoms List (as a Column)
                  if (filteredSymptoms.isEmpty)
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.medical_services_outlined,
                            color: lightTextColor,
                            size: 100,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No symptoms recorded',
                            style: GoogleFonts.nunito(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Your $periodLabel symptoms will appear here',
                            style: GoogleFonts.nunito(
                              color: lightTextColor,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: List.generate(
                          filteredSymptoms.length,
                          (index) => Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: SymptomCard(
                              symptom: filteredSymptoms[index],
                              onResolved: () {
                                context
                                    .read<SymptomsHistoryProvider>()
                                    .markSymptomResolved(
                                      filteredSymptoms[index].id,
                                    );
                                _showResolvedSnackbar(context);
                              },
                              onAddNotes: (notes) {
                                context
                                    .read<SymptomsHistoryProvider>()
                                    .addFollowUpNotes(
                                      filteredSymptoms[index].id,
                                      notes,
                                    );
                                _showNotesSnackbar(context);
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
