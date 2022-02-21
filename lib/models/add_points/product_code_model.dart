// ignore_for_file: avoid_catches_without_on_clauses

import 'package:bausch/exceptions/response_parse_exception.dart';

class ProductCodeModel {
  final int id;
  final String title;
  final String code;

  ProductCodeModel({
    required this.id,
    required this.title,
    required this.code,
  });

  factory ProductCodeModel.fromMap(Map<String, dynamic> map) {
    try {
      return ProductCodeModel(
        id: map['id'] as int,
        title: map['title'] as String,
        code: map['code'] as String,
      );
    } catch (e) {
      throw ResponseParseException('ProductCodeModel: $e');
    }
  }
}
