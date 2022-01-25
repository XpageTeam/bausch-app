// ignore_for_file: avoid_catches_without_on_clauses

import 'package:bausch/exceptions/response_parse_exception.dart';

class OtherModel {
  final String id;
  final String title;

  OtherModel({
    required this.id,
    required this.title,
  });

  factory OtherModel.fromMap(Map<String, dynamic> map) {
    try {
    return OtherModel(
      id: map['id'] as String,
      title: map['title'] as String,
    );
      
    } catch (e) {
      throw ResponseParseException('OtherModel: $e');
    }
  }
}
