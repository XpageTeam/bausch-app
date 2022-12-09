import 'package:bausch/exceptions/response_parse_exception.dart';

class LensProductListModel {
  final List<LensProductModel> products;

  LensProductListModel({
    required this.products,
  });

  factory LensProductListModel.fromMap(List<dynamic> parsedJson) {
    final productsList = parsedJson
        // ignore: avoid_annotating_with_dynamic
        .map((dynamic i) => LensProductModel.fromMap(i as Map<String, dynamic>))
        .toList();

    return LensProductListModel(
      products: productsList,
    );
  }
}

class LensProductModel {
// Диоптрии - D
// Цилиндр - CYL
// Ось - AXIS
// Аддидация - ADD
// Базовая кривизна - BC

  final int id;
  // это поле используется в разделе добавления баллов
  final int? bauschProductId;
  final int lifeTime;
  final String count;
  final String image;
  final String name;
  final List<String> diopters;
  final List<String> cylinder;
  final List<String> basicCurvature;
  final List<String> axis;
  final List<String> addition;

  LensProductModel({
    required this.id,
    required this.name,
    required this.lifeTime,
    required this.image,
    required this.count,
    required this.diopters,
    required this.cylinder,
    required this.axis,
    required this.basicCurvature,
    required this.addition,
    this.bauschProductId,
  });

  factory LensProductModel.fromMap(Map<String, dynamic> map) {
    try {
      return LensProductModel(
        id: map['id'] as int,
        bauschProductId: map['productId'] as int?,
        lifeTime: map['lifeTime'] as int,
        image: map['image'] as String,
        name: map['name'] as String,
        count: map['count'] as String,
        diopters: (map['diopters'] as List<dynamic>)
            // ignore: avoid_annotating_with_dynamic
            .map((dynamic diopter) => diopter as String)
            .toList(),
        cylinder: (map['cylinder'] as List<dynamic>)
            // ignore: avoid_annotating_with_dynamic
            .map((dynamic cylinder) => cylinder as String)
            .toList(),
        axis: (map['axis'] as List<dynamic>)
            // ignore: avoid_annotating_with_dynamic
            .map((dynamic axis) => axis as String)
            .toList(),
        addition: (map['addition'] as List<dynamic>)
            // ignore: avoid_annotating_with_dynamic
            .map((dynamic addition) => addition as String)
            .toList(),
        basicCurvature: (map['basicCurvature'] as List<dynamic>)
            // ignore: avoid_annotating_with_dynamic
            .map((dynamic basicCurvature) => basicCurvature as String)
            .toList(),
      );
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      throw ResponseParseException('Ошибка в LensProductModel: $e');
    }
  }
}
