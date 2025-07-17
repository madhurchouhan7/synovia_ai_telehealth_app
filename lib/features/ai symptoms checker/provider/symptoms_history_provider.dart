import 'package:flutter/material.dart';
import 'package:synovia_ai_telehealth_app/features/symptoms_history/models/symptom_record.dart';
import 'package:synovia_ai_telehealth_app/features/symptoms_history/services/symptoms_history_service.dart';

class SymptomsHistoryProvider extends ChangeNotifier {
  final SymptomsHistoryService _symptomsHistoryService = SymptomsHistoryService();
  
  List<SymptomRecord> _allSymptoms = [];
  List<SymptomRecord> _activeSymptoms = [];
  List<SymptomRecord> _lastWeekSymptoms = [];
  List<SymptomRecord> _lastMonthSymptoms = [];
  Map<String, dynamic> _healthInsights = {};
  bool _isLoading = false;
  String? _error;

  // Getters
  List<SymptomRecord> get allSymptoms => _allSymptoms;
  List<SymptomRecord> get activeSymptoms => _activeSymptoms;
  List<SymptomRecord> get lastWeekSymptoms => _lastWeekSymptoms;
  List<SymptomRecord> get lastMonthSymptoms => _lastMonthSymptoms;
  Map<String, dynamic> get healthInsights => _healthInsights;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load all symptoms history
  Future<void> loadSymptomsHistory() async {
    _setLoading(true);
    _clearError();
    
    try {
      _allSymptoms = await _symptomsHistoryService.getSymptomHistory();
      _activeSymptoms = await _symptomsHistoryService.getActiveSymptoms();
      _lastWeekSymptoms = await _symptomsHistoryService.getLastWeekSymptoms();
      _lastMonthSymptoms = await _symptomsHistoryService.getLastMonthSymptoms();
      _healthInsights = await _symptomsHistoryService.getHealthInsights();
      
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Load only active symptoms (for home page)
  Future<void> loadActiveSymptoms() async {
    _setLoading(true);
    _clearError();
    
    try {
      _activeSymptoms = await _symptomsHistoryService.getActiveSymptoms();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Mark symptom as resolved
  Future<void> markSymptomResolved(String symptomId) async {
    _setLoading(true);
    _clearError();
    
    try {
      await _symptomsHistoryService.markSymptomResolved(symptomId);
      // Reload active symptoms
      await loadActiveSymptoms();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Add follow-up notes
  Future<void> addFollowUpNotes(String symptomId, String notes) async {
    _setLoading(true);
    _clearError();
    
    try {
      await _symptomsHistoryService.addFollowUpNotes(symptomId, notes);
      // Reload symptoms history
      await loadSymptomsHistory();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Get symptoms by severity
  Future<List<SymptomRecord>> getSymptomsBySeverity(String severity) async {
    try {
      return await _symptomsHistoryService.getSymptomsBySeverity(severity);
    } catch (e) {
      _setError(e.toString());
      return [];
    }
  }

  // Get symptoms by time period
  Future<List<SymptomRecord>> getSymptomsByPeriod({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      return await _symptomsHistoryService.getSymptomsByPeriod(
        startDate: startDate,
        endDate: endDate,
      );
    } catch (e) {
      _setError(e.toString());
      return [];
    }
  }

  // Get health insights
  Future<Map<String, dynamic>> getHealthInsights() async {
    try {
      _healthInsights = await _symptomsHistoryService.getHealthInsights();
      notifyListeners();
      return _healthInsights;
    } catch (e) {
      _setError(e.toString());
      return {};
    }
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  // Get severity color
  Color getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'low':
        return Colors.green;
      case 'mild':
        return Colors.orange;
      case 'risky':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Get severity icon
  IconData getSeverityIcon(String severity) {
    switch (severity.toLowerCase()) {
      case 'low':
        return Icons.check_circle;
      case 'mild':
        return Icons.warning;
      case 'risky':
        return Icons.error;
      default:
        return Icons.help;
    }
  }

  // Format date
  String formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}