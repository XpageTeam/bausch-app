// ignore_for_file: avoid_catches_without_on_clauses

import 'package:bausch/exceptions/response_parse_exception.dart';

class ValueModel {
  final int id;
  final String name;

  ValueModel({
    required this.id,
    required this.name,
  });

  factory ValueModel.fromMap(Map<String, dynamic> map) {
    try {
      return ValueModel(
        id: map['id'] as int,
        name: (map['name'] ?? map['title']) as String,
      );
    } catch (e) {
      throw ResponseParseException('ValueModel: $e');
    }
  }
}
