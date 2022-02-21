// ignore_for_file: avoid_catches_without_on_clauses

import 'package:bausch/exceptions/response_parse_exception.dart';

class SpecificationModel {
  final String title;
  final String value;

  SpecificationModel({
    required this.title,
    required this.value,
  });

  factory SpecificationModel.fromMap(Map<String, dynamic> map) {
    try {
      return SpecificationModel(
        title: map['title'] as String,
        value: map['value'] as String,
      );
    } catch (e) {
      throw ResponseParseException('SpecificationModel: $e');
    }
  }
}
