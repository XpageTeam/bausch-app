// ignore_for_file: avoid_catches_without_on_clauses

import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/models/my_lenses/lens_product_list_model.dart';

class LensesPairModel {
  final int? id;
  final int? productId;
  final PairModel left;
  final PairModel right;
  final LensProductModel? product;

  LensesPairModel({
    required this.left,
    required this.right,
    this.product,
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
        product:
            LensProductModel.fromMap(map['product'] as Map<String, dynamic>),
      );
    } catch (e) {
      throw ResponseParseException('Ошибка в LensesPairModel: $e');
    }
  }
}

// TODO(pavlov): узнать может ли тут придти нал
class PairModel {
  final String? diopters;
  final String? cylinder;
  final String? basicCurvature;
  final String? axis;
  final String? addition;

  PairModel({
    required this.diopters,
    required this.cylinder,
    required this.axis,
    required this.addition,
    required this.basicCurvature,
  });

  factory PairModel.fromMap(Map<String, dynamic> map) {
    try {
      return PairModel(
        diopters: map['diopters'] as String?,
        cylinder: map['cylinder'] as String?,
        axis: map['axis'] as String?,
        addition: map['addition'] as String?,
        // TODO(ask): не приходят с бэка
        basicCurvature: map['basicCurvature'] as String?,
      );
    } catch (e) {
      throw ResponseParseException('Ошибка в PairModel: $e');
    }
  }

  PairModel copyWith({
    String? diopters,
    String? cylinder,
    String? axis,
    String? addition,
    String? basicCurvature,
  }) {
    return PairModel(
      diopters: diopters ?? this.diopters,
      cylinder: cylinder ?? this.cylinder,
      axis: axis ?? this.axis,
      addition: addition ?? this.addition,
      basicCurvature: basicCurvature ?? this.basicCurvature,
    );
  }
}
