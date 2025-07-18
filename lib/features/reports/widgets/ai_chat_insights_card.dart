import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:synovia_ai_telehealth_app/features/symptoms_history/models/symptom_record.dart';
import 'package:synovia_ai_telehealth_app/core/colors.dart';
import 'package:fl_chart/fl_chart.dart';

class AiChatInsightsCard extends StatefulWidget {
  final List<SymptomRecord> symptoms;
  final bool isLoading;

  const AiChatInsightsCard({
    super.key,
    required this.symptoms,
    this.isLoading = false,
  });

  @override
  State<AiChatInsightsCard> createState() => _AiChatInsightsCardState();
}

class _AiChatInsightsCardState extends State<AiChatInsightsCard> {
  String _selectedAdviceType = 'All';
  final Map<String, Color> _adviceColors = {
    'See Doctor': Colors.red,
    'Self-care': Colors.green,
    'Monitor': Colors.orange,
    'Other': Colors.blueGrey,
  };
  final Map<String, String> _adviceKeywords = {
    'See Doctor': 'doctor',
    'Self-care': 'rest',
    'Monitor': 'monitor',
  };
  final Set<int> _expandedIndexes = {};

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (widget.symptoms.isEmpty) {
      return Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            'No AI chat history available',
            style: GoogleFonts.nunito(color: Colors.white70, fontSize: 16),
          ),
        ),
      );
    }

    final adviceTypeCounts = _getAdviceTypeCounts(widget.symptoms);
    final filteredSymptoms =
        _selectedAdviceType == 'All'
            ? widget.symptoms
            : widget.symptoms
                .where((s) => _getAdviceType(s.aiAdvice) == _selectedAdviceType)
                .toList();
    final sortedSymptoms = List<SymptomRecord>.from(filteredSymptoms)
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.chat_bubble_outline, color: brandColor, size: 24),
              const SizedBox(width: 8),
              Text(
                'AI Chat Insights',
                style: GoogleFonts.nunito(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Advice Type Distribution',
            style: GoogleFonts.nunito(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20), // Increased spacing to prevent overlap
          SizedBox(
            height: 120,
            child: PieChart(
              PieChartData(
                sections:
                    adviceTypeCounts.entries.map((entry) {
                      return PieChartSectionData(
                        value: entry.value.toDouble(),
                        title: entry.key,
                        color: _adviceColors[entry.key] ?? Colors.blueGrey,
                        radius: 48,
                        titleStyle: GoogleFonts.nunito(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }).toList(),
                centerSpaceRadius: 30,
              ),
            ),
          ),
          const SizedBox(height: 20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildAdviceTypeChip('All'),
                ...adviceTypeCounts.keys.map(_buildAdviceTypeChip),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ...sortedSymptoms.asMap().entries.map((entry) {
            final idx = entry.key;
            final symptom = entry.value;
            final expanded = _expandedIndexes.contains(idx);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (expanded) {
                    _expandedIndexes.remove(idx);
                  } else {
                    _expandedIndexes.add(idx);
                  }
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[800]!),
                  boxShadow:
                      expanded
                          ? [
                            BoxShadow(
                              color: brandColor.withOpacity(0.1),
                              blurRadius: 8,
                            ),
                          ]
                          : [],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color:
                                _adviceColors[_getAdviceType(symptom.aiAdvice)]
                                    ?.withOpacity(0.2) ??
                                Colors.blueGrey.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _getAdviceType(symptom.aiAdvice),
                            style: GoogleFonts.nunito(
                              color:
                                  _adviceColors[_getAdviceType(
                                    symptom.aiAdvice,
                                  )] ??
                                  Colors.blueGrey,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          _formatDate(symptom.timestamp),
                          style: GoogleFonts.nunito(
                            color: Colors.white60,
                            fontSize: 12,
                          ),
                        ),
                        Icon(
                          expanded ? Icons.expand_less : Icons.expand_more,
                          color: Colors.white38,
                          size: 20,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      symptom.symptoms,
                      style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (symptom.aiAdvice.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      _buildPersonalizedAdvice(
                        context,
                        _extractKeyInsight(symptom.aiAdvice),
                        _getAdviceType(symptom.aiAdvice),
                        expanded,
                      ),
                    ],
                    if (expanded && symptom.aiAdvice.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      _buildPersonalizedAdvice(
                        context,
                        symptom.aiAdvice,
                        _getAdviceType(symptom.aiAdvice),
                        true,
                      ),
                    ],
                    if (symptom.followUpNotes?.isNotEmpty == true) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.note, color: brandColor, size: 14),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              'Notes: ${symptom.followUpNotes}',
                              style: GoogleFonts.nunito(
                                color: brandColor,
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),
          if (filteredSymptoms.length > 3)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Center(
                child: Text(
                  '${filteredSymptoms.length - 3} more conversations...',
                  style: GoogleFonts.nunito(
                    color: brandColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAdviceTypeChip(String type) {
    final selected = _selectedAdviceType == type;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ChoiceChip(
        label: Text(
          type,
          style: GoogleFonts.nunito(
            color: selected ? Colors.white : Colors.white70,
          ),
        ),
        selected: selected,
        selectedColor: brandColor,
        backgroundColor: Colors.grey[800],
        onSelected: (_) {
          setState(() => _selectedAdviceType = type);
        },
      ),
    );
  }

  Map<String, int> _getAdviceTypeCounts(List<SymptomRecord> symptoms) {
    final counts = <String, int>{};
    for (final s in symptoms) {
      final type = _getAdviceType(s.aiAdvice);
      counts[type] = (counts[type] ?? 0) + 1;
    }
    return counts;
  }

  String _getAdviceType(String aiAdvice) {
    final advice = aiAdvice.toLowerCase();
    if (advice.contains('doctor') ||
        advice.contains('specialist') ||
        advice.contains('emergency')) {
      return 'See Doctor';
    } else if (advice.contains('rest') ||
        advice.contains('hydration') ||
        advice.contains('self-care')) {
      return 'Self-care';
    } else if (advice.contains('monitor') || advice.contains('watch')) {
      return 'Monitor';
    }
    return 'Other';
  }

  String _formatDate(DateTime date) {
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

  String _extractKeyInsight(String aiAdvice) {
    if (aiAdvice.isEmpty) return '';
    final recommendations = [
      'recommend',
      'suggest',
      'advise',
      'consider',
      'should',
      'important',
    ];
    final sentences = aiAdvice.split('.');
    for (final sentence in sentences) {
      final lowerSentence = sentence.toLowerCase();
      for (final keyword in recommendations) {
        if (lowerSentence.contains(keyword)) {
          return sentence.trim();
        }
      }
    }
    return sentences.first.trim();
  }

  Widget _buildPersonalizedAdvice(
    BuildContext context,
    String advice,
    String adviceType,
    bool expanded,
  ) {
    // If advice is only 'see doctor' or similar, add a friendly message
    final lower = advice.trim().toLowerCase();
    final isOnlySeeDoctor =
        (lower == 'see a doctor' ||
            lower == 'see doctor' ||
            lower == 'consult a doctor' ||
            lower == 'consult your doctor' ||
            lower == 'consult specialist' ||
            lower == 'emergency' ||
            lower == 'see a specialist');
    if (isOnlySeeDoctor) {
      return Row(
        children: [
          Icon(Icons.favorite, color: brandColor, size: 16),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              'We recommend seeing a doctor for your symptoms. Your health matters—don’t hesitate to seek help! 💚',
              style: GoogleFonts.nunito(
                color: brandColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              maxLines: expanded ? 8 : 2,
              overflow: expanded ? TextOverflow.visible : TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    }
    // Highlight keywords in advice
    final highlightWords = [
      'rest',
      'hydration',
      'monitor',
      'emergency',
      'doctor',
      'specialist',
      'watch',
      'self-care',
      'important',
      'should',
      'recommend',
      'advise',
      'suggest',
      'consider',
    ];
    String highlighted = advice;
    for (final word in highlightWords) {
      highlighted = highlighted.replaceAllMapped(
        RegExp(
          '(?<![\\w])(' + RegExp.escape(word) + ')(?![\\w])',
          caseSensitive: false,
        ),
        (match) => '[${match[0]}]',
      );
    }
    // Split and build TextSpan for highlights
    final spans = <TextSpan>[];
    final parts = highlighted.split(RegExp(r'(\[|\])'));
    bool highlight = false;
    for (final part in parts) {
      if (part == '[') {
        highlight = true;
        continue;
      } else if (part == ']') {
        highlight = false;
        continue;
      }
      spans.add(
        TextSpan(
          text: part,
          style:
              highlight
                  ? GoogleFonts.nunito(
                    color: brandColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  )
                  : GoogleFonts.nunito(color: Colors.white70, fontSize: 14),
        ),
      );
    }
    return RichText(
      text: TextSpan(children: spans),
      maxLines: expanded ? 8 : 2,
      overflow: expanded ? TextOverflow.visible : TextOverflow.ellipsis,
    );
  }
}
