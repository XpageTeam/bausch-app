

// ignore_for_file: avoid_catches_without_on_clauses

import 'package:bausch/exceptions/response_parse_exception.dart';

class PreviewModel{
  final String title;

  final String description;

  PreviewModel({
    required this.title,
    required this.description,
  });

  factory PreviewModel.fromMap(Map<String, dynamic> map) {
    try {
      return PreviewModel(
        title: map['title'] as String,
        description: map['description'] as String,
      );
    } catch (e) {
      throw ResponseParseException('PreviewModel: $e');
    }
  }

}
