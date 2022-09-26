import 'package:bausch/exceptions/response_parse_exception.dart';

class RemindersBuyModel {
  final String replay;
  final String date;
  final List<String> reminders;

  RemindersBuyModel({
    required this.date,
    required this.replay,
    required this.reminders,
  });

  factory RemindersBuyModel.fromMap(Map<String, dynamic> map) {
    try {
      return RemindersBuyModel(
        replay: map['replay'] as String,
        date: map['date'] as String,
        reminders: (map['reminders'] as List<dynamic>)
            // ignore: avoid_annotating_with_dynamic
            .map((dynamic diopter) => diopter as String)
            .toList(),
      );
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      throw ResponseParseException('Ошибка в RemindersBuyModel: $e');
    }
  }
}
