// ignore_for_file: avoid_annotating_with_dynamic, avoid_catches_without_on_clauses

import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/models/faq/forms/value_model.dart';

class FieldModel {
  final int id;
  final String type;
  final String name;
  final String xmlId;
  final List<ValueModel>? values;
  final bool? isRequired;

  FieldModel({
    required this.id,
    required this.type,
    required this.name,
    required this.xmlId,
    this.isRequired,
    this.values,
  });

  factory FieldModel.fromMap(Map<String, dynamic> map) {
    try {
      return FieldModel(
        id: map['id'] as int,
        type: map['type'] as String,
        name: map['name'] as String,
        xmlId: map['xml_id'] as String,
        isRequired: map['required'] != null ? map['required'] as bool : null,
        values: map['values'] != null
            ? (map['values'] as List<dynamic>)
                .map((dynamic e) =>
                    ValueModel.fromMap(e as Map<String, dynamic>))
                .toList()
            : [],
      );
    } catch (e) {
      throw ResponseParseException('FieldModel: $e');
    }
  }
}
