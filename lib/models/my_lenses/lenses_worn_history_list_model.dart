import 'package:bausch/exceptions/response_parse_exception.dart';

class LensesWornHistoryListModel {
  final List<LensesWornHistoryModel> wornHistory;

  LensesWornHistoryListModel({
    required this.wornHistory,
  });

  factory LensesWornHistoryListModel.fromMap(List<dynamic> parsedJson) {
    final historyList = parsedJson
        // ignore: avoid_annotating_with_dynamic
        .map((dynamic i) =>
            LensesWornHistoryModel.fromMap(i as Map<String, dynamic>))
        .toList();

    return LensesWornHistoryListModel(wornHistory: historyList);
  }
}

class LensesWornHistoryModel {
  final String eye;
  final DateTime dateStart;
  final DateTime? dateEnd;

  LensesWornHistoryModel({
    required this.eye,
    required this.dateStart,
    required this.dateEnd,
  });

  factory LensesWornHistoryModel.fromMap(Map<String, dynamic> map) {
    try {
      return LensesWornHistoryModel(
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
