// ignore_for_file: avoid_catches_without_on_clauses

import 'package:bausch/exceptions/response_parse_exception.dart';

class QuizAnswerModel {
  final String id;
  final String title;
  final String type;

  QuizAnswerModel({
    required this.id,
    required this.title,
    required this.type,
  });

  factory QuizAnswerModel.fromMap(Map<String, dynamic> map, String type) {
    try {
      return QuizAnswerModel(
        id: map['id'] as String,
        title: map['title'] as String,
        type: type,
      );
    } catch (e) {
      throw ResponseParseException('QuizAnswerModel: $e');
    }
  }

  Map<String, String> toMap() {
    return {
      'id': id,
      'title': title,
    };
  }
}
