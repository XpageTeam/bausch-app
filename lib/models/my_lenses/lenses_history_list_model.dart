import 'package:bausch/exceptions/response_parse_exception.dart';

class LensesHistoryListModel {
  final List<LensesHistoryModel> lensesHistory;

  LensesHistoryListModel({
    required this.lensesHistory,
  });

  factory LensesHistoryListModel.fromMap(List<dynamic> parsedJson) {
    final historyList = parsedJson
        // ignore: avoid_annotating_with_dynamic
        .map((dynamic i) =>
            LensesHistoryModel.fromMap(i as Map<String, dynamic>))
        .toList();

    return LensesHistoryListModel(lensesHistory: historyList);
  }
}

class LensesHistoryModel {
  final String eye;
  final DateTime dateStart;
  final DateTime? dateEnd;

  LensesHistoryModel({
    required this.eye,
    required this.dateStart,
    required this.dateEnd,
  });

  factory LensesHistoryModel.fromMap(Map<String, dynamic> map) {
    try {
      return LensesHistoryModel(
        eye: map['eye'] as String,
        dateStart: DateTime.parse(map['dateStart'] as String),
        dateEnd: map['dateEnd'] != null
            ? DateTime.parse(map['dateEnd'] as String)
            : null,
      );
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      throw ResponseParseException('Ошибка в LensesHistoryModel: $e');
    }
  }
}
