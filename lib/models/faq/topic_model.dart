// ignore_for_file: avoid_annotating_with_dynamic, avoid_catches_without_on_clauses

import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/models/faq/question_model.dart';
import 'package:bausch/models/mappable_object.dart';

class TopicModel implements MappableInterface<TopicModel> {
  //* Идентификаор темы
  final int id;

  //* Название темы
  final String title;

  //* Список вопросов
  final List<QuestionModel>? questions;

  final String? answer;

  TopicModel({
    required this.id,
    required this.title,
    required this.questions,
    this.answer,
  });

  factory TopicModel.fromMap(Map<String, dynamic> map) {
    if (map['id'] == null) {
      throw ResponseParseException('Не передан идентификатор темы');
    }

    if (map['title'] == null) {
      throw ResponseParseException('Не передано название темы');
    }

    // if (map['questions'] == null) {
    //   throw ResponseParseException('Не передан список вопросов по теме');
    // }

    try {
      return TopicModel(
        id: map['id'] as int,
        title: map['title'] as String,
        answer: map['answer'] as String?,
        questions: map['questions'] != null
            ? (map['questions'] as List<dynamic>)
                .map(
                  (dynamic e) => QuestionModel.fromMap(
                    e as Map<String, dynamic>,
                  ),
                )
                .toList()
            : null,
      );
    } catch (e) {
      throw ResponseParseException('TopicModel: $e');
    }
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'questions': questions,
    };
  }
}
