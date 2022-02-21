// ignore_for_file: avoid_catches_without_on_clauses

import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/models/catalog_item/product_item_model.dart';

class ProgramModel {
  final String title;

  final String description;

  final List<ProductItemModel> products;

  final List<String> importantToKnow;

  final List<String> whatDoYouUse;

  ProgramModel({
    required this.title,
    required this.description,
    required this.products,
    required this.importantToKnow,
    required this.whatDoYouUse,
  });

  factory ProgramModel.fromMap(Map<String, dynamic> map) {
    try {
      return ProgramModel(
        title: map['title'] as String,
        description: map['description'] as String,
        products: (map['products'] as List<dynamic>)
            // ignore: avoid_annotating_with_dynamic
            .map((dynamic product) =>
                ProductItemModel.fromMap(product as Map<String, dynamic>))
            .toList(),
        importantToKnow: List.from(map['importantToKnow'] as List<dynamic>),
        whatDoYouUse: List.from(map['whatDoYouUse'] as List<dynamic>),
      );
    } catch (e) {
      throw ResponseParseException('ProgramModel: $e');
    }
  }
}
