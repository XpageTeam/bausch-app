import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/help/help_functions.dart';
import 'package:intl/intl.dart';

class NotificationModel {
  final int id;
  final String title;
  final int? points;
  final String? type;
  final DateTime? date;
  final bool? read;

  String? get formatedDate =>
      date != null ? DateFormat('dd.MM.yyyy').format(date!) : null;

  String get formatedPrice => points != null
      ? (points!.isNegative
          ? HelpFunctions.partitionNumber(points!)
          : '+${HelpFunctions.partitionNumber(points!)}')
      : '';

  /// Если присутствует ссылка, то возвращаю [title] без ссылки, иначе - просто возвращаю [title]
  String get tilteWithoutUrl {
    final splittedText = title.split(' ');
    final indexOfUrl = _tryGetIndexOfUrl(splittedText);

    if (indexOfUrl == -1) return title;

    final splittedTitleWithouUrl = splittedText..removeAt(indexOfUrl);
    return '${splittedTitleWithouUrl.join(' ')} ';
  }

  /// Если присутсвует ссылка в [title], то возвращаю эту ссылку, иначе возвращаю null
  String? get url {
    final splittedText = title.split(' ');
    final indexOfUrl = _tryGetIndexOfUrl(splittedText);

    if (indexOfUrl == -1) return null;

    return splittedText.elementAt(indexOfUrl);
  }

  const NotificationModel({
    required this.id,
    required this.title,
    this.points,
    this.type,
    this.date,
    this.read,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    try {
      return NotificationModel(
        id: map['id'] as int,
        title: map['title'] as String? ?? '',
        points: map['price'] as int?,
        type: map['type'] as String?,
        read: map['read'] as bool?,
        date: DateTime.tryParse(map['date'] as String? ?? ''),
      );
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      throw ResponseParseException('NotificationModel: ${e.toString()}');
    }
  }

  /// Поиск индекса ссылки в разбитом по пробелам [title]
  int _tryGetIndexOfUrl(List<String> splittedText) {
    return splittedText.indexWhere(
      (element) => element.startsWith(
        'http',
      ),
    );
  }
}
