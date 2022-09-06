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
  final int id;
  final int lifeTime;
  final String image;
  final String name;

  LensProductModel({
    required this.id,
    required this.name,
    required this.lifeTime,
    required this.image,
  });

  factory LensProductModel.fromMap(Map<String, dynamic> map) {
    try {
      return LensProductModel(
        id: map['id'] as int,
        lifeTime: map['lifeTime'] as int,
        image: map['image'] as String,
        name: map['name'] as String,
      );
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      throw ResponseParseException('Ошибка в LensesPairModel: $e');
    }
  }
}
