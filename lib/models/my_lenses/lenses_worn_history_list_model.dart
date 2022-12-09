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
  final bool? left;
  final bool? right;
  final bool? leftRight;
  final DateTime? dateStartL;
  final DateTime? dateStartR;
  final DateTime? dateEndL;
  final DateTime? dateEndR;

  LensesWornHistoryModel({
    required this.left,
    required this.right,
    required this.leftRight,
    required this.dateStartL,
    required this.dateStartR,
    required this.dateEndL,
    required this.dateEndR,
  });

  factory LensesWornHistoryModel.fromMap(Map<String, dynamic> map) {
    try {
      return LensesWornHistoryModel(
        left: map['L'] as bool?,
        right: map['R'] as bool?,
        leftRight: map['LR'] as bool?,
        dateStartL: map['DateStartL'] != null
            ? DateTime.parse(map['DateStartL'] as String)
            : null,
        dateStartR: map['DateStartR'] != null
            ? DateTime.parse(map['DateStartR'] as String)
            : null,
        dateEndL: map['DateEndL'] != null
            ? DateTime.parse(map['DateEndL'] as String)
            : null,
        dateEndR: map['DateEndR'] != null
            ? DateTime.parse(map['DateEndR'] as String)
            : null,
      );
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      throw ResponseParseException('Ошибка в LensesWornHistoryModel: $e');
    }
  }
}
