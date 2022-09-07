// ignore_for_file: avoid_catches_without_on_clauses

import 'package:bausch/exceptions/response_parse_exception.dart';

// TODO(ask): разобраться какие поля могут быть null
class LensesPairModel {
  final int? id;
  final int? productId;
  // эти поля могут быть налом, или их внутренности нал когда они нал?
  final PairModel left;
  final PairModel right;

  LensesPairModel({
    required this.left,
    required this.right,
    this.productId,
    this.id,
  });

  factory LensesPairModel.fromMap(Map<String, dynamic> map) {
    try {
      return LensesPairModel(
        id: map['id'] as int?,
        productId: map['product_id'] as int?,
        left: PairModel.fromMap(map['left_eye'] as Map<String, dynamic>),
        right: PairModel.fromMap(map['right_eye'] as Map<String, dynamic>),
      );
    } catch (e) {
      throw ResponseParseException('Ошибка в LensesPairModel: $e');
    }
  }
}

class PairModel {
  final String? diopters;
  final String? cylinder;
  final String? axis;
  final String? addition;

  PairModel({
    required this.diopters,
    required this.cylinder,
    required this.axis,
    required this.addition,
  });

  factory PairModel.fromMap(Map<String, dynamic> map) {
    try {
      return PairModel(
        diopters: map['diopters'] as String,
        cylinder: map['cylinder'] as String,
        axis: map['axis'] as String,
        addition: map['addition'] as String,
      );
    } catch (e) {
      throw ResponseParseException('Ошибка в баннер модел: $e');
    }
  }

  PairModel copyWith({
    String? diopters,
    String? cylinder,
    String? axis,
    String? addition,
  }) {
    return PairModel(
      diopters: diopters ?? this.diopters,
      cylinder: cylinder ?? this.cylinder,
      axis: axis ?? this.axis,
      addition: addition ?? this.addition,
    );
  }
}
