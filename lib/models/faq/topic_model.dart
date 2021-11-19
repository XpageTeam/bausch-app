// ignore_for_file: avoid_annotating_with_dynamic

import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/models/faq/question_model.dart';
import 'package:bausch/models/mappable_object.dart';

class TopicModel implements MappableInterface<TopicModel> {
  //* Идентификаор темы
  final int id;

  //* Название темы
  final String title;

  //* Список вопросов
  final List<QuestionModel> questions;

  TopicModel({required this.id, required this.title, required this.questions});

  factory TopicModel.fromMap(Map<String, dynamic> map) {
    if (map['id'] == null) {
      throw ResponseParseException('Не передан идентификатор темы');
    }

    if (map['title'] == null) {
      throw ResponseParseException('Не передано название темы');
    }

    if (map['questions'] == null) {
      throw ResponseParseException('Не передан список вопросов по теме');
    }

    return TopicModel(
      id: map['id'] as int,
      title: map['title'] as String,
      questions: (map['questions'] as List<dynamic>)
          .map((dynamic e) => QuestionModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
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
