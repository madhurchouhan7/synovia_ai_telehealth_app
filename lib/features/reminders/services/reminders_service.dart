import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/reminder.dart';

class RemindersService {
  final _remindersRef = FirebaseFirestore.instance.collection('reminders');

  Future<List<Reminder>> getReminders(String userId) async {
    final snapshot =
        await _remindersRef.where('userId', isEqualTo: userId).get();
    return snapshot.docs
        .map((doc) => Reminder.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<void> addReminder(String userId, Reminder reminder) async {
    await _remindersRef.add({...reminder.toMap(), 'userId': userId});
  }

  Future<void> deleteReminder(String reminderId) async {
    await _remindersRef.doc(reminderId).delete();
  }
}
