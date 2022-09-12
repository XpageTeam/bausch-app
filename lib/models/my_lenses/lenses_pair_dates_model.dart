// ignore_for_file: avoid_catches_without_on_clauses

import 'package:bausch/exceptions/response_parse_exception.dart';

class LensesPairDatesModel {
  final LensDateModel? left;
  final LensDateModel? right;

  LensesPairDatesModel({
    required this.left,
    required this.right,
  });

  factory LensesPairDatesModel.fromMap(Map<String, dynamic> map) {
    try {
      // TODO(info): проставить в налах вопросы в запросах
      return LensesPairDatesModel(
        left: map['left'] != null
            ? LensDateModel.fromMap(map['left'] as Map<String, dynamic>)
            : null,
        right: map['right'] != null
            ? LensDateModel.fromMap(map['right'] as Map<String, dynamic>)
            : null,
      );
    } catch (e) {
      throw ResponseParseException('Ошибка в LensesPairDatesModel: $e');
    }
  }
}

class LensDateModel {
  // TODO(ask): попросить передавать DateTime, а не String
  final DateTime dateStart;
  final DateTime dateEnd;
  final int daysLeft;

  LensDateModel({
    required this.dateStart,
    required this.dateEnd,
    required this.daysLeft,
  });

  factory LensDateModel.fromMap(Map<String, dynamic> map) {
    try {
      return LensDateModel(
        dateStart: map['dateStart'] as DateTime,
        dateEnd: map['dateEnd'] as DateTime,
        daysLeft: map['daysLeft'] as int,
      );
    } catch (e) {
      throw ResponseParseException('Ошибка в PairDateModel: $e');
    }
  }

  LensDateModel copyWith({
    DateTime? dateStart,
    DateTime? dateEnd,
    int? daysLeft,
  }) {
    return LensDateModel(
      dateStart: dateStart ?? this.dateStart,
      dateEnd: dateEnd ?? this.dateEnd,
      daysLeft: daysLeft ?? this.daysLeft,
    );
  }
}
