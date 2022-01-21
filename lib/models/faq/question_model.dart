// ignore_for_file: avoid_catches_without_on_clauses, avoid_annotating_with_dynamic

import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/models/mappable_object.dart';

class QuestionModel implements MappableInterface<QuestionModel> {
  final int id;

  //* Формулировка вопроса
  final String title;

  //* Ответ на вопрс
  final String? answer;

  //* Поля для формы
  final List<QuestionField>? fields;

  QuestionModel({
    required this.id, 
    required this.title, 
    this.answer,
    this.fields,
  });

  factory QuestionModel.fromMap(Map<String, dynamic> map) {
    if (map['id'] == null) {
      throw ResponseParseException('Не передан идентификатор вопроса');
    }

    if (map['title'] == null) {
      throw ResponseParseException('Не передана формулировка вопроса');
    }

    try {
      return QuestionModel(
        id: map['id'] as int,
        title: map['title'] as String,
        answer: map['answer'] as String?,
        fields: (map['fields'] as List<dynamic>?)?.map((dynamic field){
          return QuestionField.fromMap(field as Map<String, dynamic>);
        }).toList(),
      );
    } catch (e) {
      throw ResponseParseException('QuestionModel: $e');
    }
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'answer': answer,
      'fields': fields,
    };
  }
}


class QuestionField {
  final String title;
  final String xmlID;
  final bool required;
  final String type;

  const QuestionField({
    required this.title,
    required this.xmlID,
    required this.required,
    required this.type,
  });

  factory QuestionField.fromMap(Map<String, dynamic> map){
    try {
      return QuestionField(
        title: map['title'] as String,
        xmlID: map['xmlId'] as String,
        required: map['required'] as bool,
        type: map['type'] as String,
      );
    } catch (e) {
      throw ResponseParseException('QuestionFields: $e');
    }
  }

}
