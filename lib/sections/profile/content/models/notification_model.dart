import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/help/help_functions.dart';
import 'package:intl/intl.dart';

class NotificationModel {
  final int id;
  final String title;
  final int? points;
  final String? type;
  final DateTime? date;

  String? get formatedDate =>
      date != null ? DateFormat('dd.MM.yyyy').format(date!) : null;

  String get formatedPrice => points != null
      ? (points!.isNegative
          ? HelpFunctions.partitionNumber(points!)
          : '+${HelpFunctions.partitionNumber(points!)}')
      : '';

  const NotificationModel({
    required this.id,
    required this.title,
    this.points,
    this.type,
    this.date,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    try {
      return NotificationModel(
        id: map['id'] as int,
        title: map['title'] as String? ?? '',
        points: map['price'] as int?,
        type: map['type'] as String?,
        date: DateTime.tryParse(map['date'] as String? ?? ''),
      );
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      throw ResponseParseException('NotificationModel: ${e.toString()}');
    }
  }
}
