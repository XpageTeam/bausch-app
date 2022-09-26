import 'package:bausch/exceptions/response_parse_exception.dart';

class RecommendedProductsListModel {
  final List<RecommendedProductModel> products;

  RecommendedProductsListModel({
    required this.products,
  });

  factory RecommendedProductsListModel.fromMap(List<dynamic> parsedJson) {
    final recommendedProducts = parsedJson
        // ignore: avoid_annotating_with_dynamic
        .map((dynamic i) =>
            RecommendedProductModel.fromMap(i as Map<String, dynamic>))
        .toList();

    return RecommendedProductsListModel(products: recommendedProducts);
  }
}

// TODO(pavlov): доделать, посмотреть что не так
class RecommendedProductModel {
  final int id;
  final String description;
  final String image;
  final String name;
  final String link;

  RecommendedProductModel({
    required this.id,
    required this.name,
    required this.link,
    required this.image,
    required this.description,
  });

  factory RecommendedProductModel.fromMap(Map<String, dynamic> map) {
    try {
      return RecommendedProductModel(
        id: map['id'] as int,
        link: map['link'] as String,
        image: map['image'] as String,
        name: map['name'] as String,
        description: map['description'] as String,
      );
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      throw ResponseParseException('Ошибка в RecommendedProductModel: $e');
    }
  }
}
