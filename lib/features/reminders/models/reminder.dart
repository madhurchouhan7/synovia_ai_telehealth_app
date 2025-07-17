class Reminder {
  final String id;
  final String title;
  final String description;
  final DateTime time;
  final String type; // 'medication' or 'follow-up'

  Reminder({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    required this.type,
  });

  factory Reminder.fromMap(Map<String, dynamic> map, String id) {
    return Reminder(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      time: DateTime.parse(map['time'] as String),
      type: map['type'] ?? 'medication',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'time': time.toIso8601String(),
      'type': type,
    };
  }
}
