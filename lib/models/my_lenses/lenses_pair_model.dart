// ignore_for_file: avoid_catches_without_on_clauses

import 'package:bausch/exceptions/response_parse_exception.dart';

// TODO(ask): разобраться какие поля могут быть null
class LensesPairModel {
  final int id;
  final PairModel left;
  final PairModel right;

  LensesPairModel({
    required this.id,
    required this.left,
    required this.right,
  });

  factory LensesPairModel.fromMap(Map<String, dynamic> map) {
    try {
      return LensesPairModel(
        id: map['pair_id'] as int,
        left: PairModel.fromMap(map['left'] as Map<String, dynamic>),
        right: PairModel.fromMap(map['right'] as Map<String, dynamic>),
      );
    } catch (e) {
      throw ResponseParseException('Ошибка в LensesPairModel: $e');
    }
  }
}

class PairModel {
  final double diopters;
  final double cylinder;
  final double axis;
  final double addition;

  PairModel({
    required this.diopters,
    required this.cylinder,
    required this.axis,
    required this.addition,
  });

  factory PairModel.fromMap(Map<String, dynamic> map) {
    try {
      return PairModel(
        diopters: map['diopters'] as double,
        cylinder: map['cylinder'] as double,
        axis: map['axis'] as double,
        addition: map['addition'] as double,
      );
    } catch (e) {
      throw ResponseParseException('Ошибка в баннер модел: $e');
    }
  }
}
