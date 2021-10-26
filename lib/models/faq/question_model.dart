import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/models/mappable_object.dart';

class QuestionModel implements MappableInterface<QuestionModel> {
  final int id;

  //* Формулировка вопроса
  final String title;

  //* Ответ на вопрс
  final String answer;

  QuestionModel({required this.id, required this.title, required this.answer});

  factory QuestionModel.fromMap(Map<String, dynamic> map) {
    if (map['id'] == null) {
      throw ResponseParseExeption('Не передан идентификатор вопроса');
    }

    if (map['title'] == null) {
      throw ResponseParseExeption('Не передана формулировка вопроса');
    }

    if (map['answer'] == null) {
      throw ResponseParseExeption('Не передан ответ на вопрос');
    }

    return QuestionModel(
      id: map['id'] as int,
      title: map['title'] as String,
      answer: map['answer'] as String,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'answer': answer,
    };
  }
}
