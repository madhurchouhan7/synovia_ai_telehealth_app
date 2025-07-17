import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:synovia_ai_telehealth_app/core/colors.dart';
import 'package:synovia_ai_telehealth_app/features/symptoms_history/provider/symptoms_history_provider.dart';
import 'package:synovia_ai_telehealth_app/features/symptoms_history/widgets/symptom_card.dart';
import 'package:synovia_ai_telehealth_app/features/symptoms_history/widgets/health_insights_card.dart';
import 'package:synovia_ai_telehealth_app/features/symptoms_history/widgets/severity_filter_chip.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedSeverity = 'all';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SymptomsHistoryProvider>().loadSymptomsHistory();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
            fontSize: fontSize * 24,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: brandColor,
          labelColor: Colors.white,
          unselectedLabelColor: lightTextColor,
          tabs: [Tab(text: 'Past'), Tab(text: 'Week'), Tab(text: 'Month')],
        ),
      ),
      body: Consumer<SymptomsHistoryProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: brandColor),
            );
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: fontSize * 60,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Error loading data',
                    style: GoogleFonts.nunito(
                      color: Colors.white,
                      fontSize: fontSize * 20,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    provider.error!,
                    style: GoogleFonts.nunito(
                      color: lightTextColor,
                      fontSize: fontSize * 26,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.loadSymptomsHistory(),
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Health Insights Card
              if (provider.healthInsights.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: HealthInsightsCard(
                    insights: provider.healthInsights,
                    fontSize: fontSize,
                  ),
                ),

              // Severity Filter Chips
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

              // Tab Content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildSymptomsList(provider.allSymptoms, 'All Time'),
                    _buildSymptomsList(provider.lastWeekSymptoms, 'Last Week'),
                    _buildSymptomsList(
                      provider.lastMonthSymptoms,
                      'Last Month',
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSymptomsList(List symptoms, String period) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth / 600;

    // Filter by severity if not 'all'
    List filteredSymptoms = symptoms;
    if (_selectedSeverity != 'all') {
      filteredSymptoms =
          symptoms
              .where((symptom) => symptom.severity == _selectedSeverity)
              .toList();
    }

    if (filteredSymptoms.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.medical_services_outlined,
              color: lightTextColor,
              size: fontSize * 80,
            ),
            SizedBox(height: 16),
            Text(
              'No symptoms recorded',
              style: GoogleFonts.nunito(
                color: Colors.white,
                fontSize: fontSize * 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Your $period symptoms will appear here',
              style: GoogleFonts.nunito(
                color: lightTextColor,
                fontSize: fontSize * 16,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: filteredSymptoms.length,
      itemBuilder: (context, index) {
        final symptom = filteredSymptoms[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: SymptomCard(
            symptom: symptom,
            onResolved: () {
              context.read<SymptomsHistoryProvider>().markSymptomResolved(
                symptom.id,
              );
            },
            onAddNotes: (notes) {
              context.read<SymptomsHistoryProvider>().addFollowUpNotes(
                symptom.id,
                notes,
              );
            },
          ),
        );
      },
    );
  }
}
