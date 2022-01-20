import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/models/faq/forms/field_model.dart';
import 'package:bausch/models/faq/forms/value_model.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:flutter/foundation.dart';

class FormsContentDownloader {
  final rh = RequestHandler();

  Future<List<FieldModel>> loadDefaultFields() async {
    final result =
        BaseResponseRepository.fromMap((await rh.get<Map<String, dynamic>>(
      '/faq/form/fields/',
    ))
            .data!);

    try {
      return (result.data as List<dynamic>)
          .map((dynamic item) =>
              FieldModel.fromMap(item as Map<String, dynamic>))
          .toList();
    } on ResponseParseException {
      rethrow;
    } catch (e) {
      throw ResponseParseException('loadDefaultFields: ${e.toString()}');
    }
  }

  Future<List<FieldModel>> loadExtraFields(int question) async {
    final result =
        BaseResponseRepository.fromMap((await rh.get<Map<String, dynamic>>(
      '/faq/form/fields/extra/',
      queryParameters: <String, dynamic>{
        'question': question,
      },
    ))
            .data!);

    try {
      return (result.data as List<dynamic>)
          .map((dynamic item) =>
              FieldModel.fromMap(item as Map<String, dynamic>))
          .toList();
    } on ResponseParseException {
      rethrow;
    } catch (e) {
      throw ResponseParseException('loadExtraFields: ${e.toString()}');
    }
  }

  Future<List<ValueModel>> loadCategoryList() async {
    final result =
        BaseResponseRepository.fromMap((await rh.get<Map<String, dynamic>>(
      '/static/faq/',
    ))
            .data!);

    try {
      return (result.data as List<dynamic>)
          .map(
            (dynamic item) => ValueModel.fromMap(item as Map<String, dynamic>),
          )
          .toList();
    } on ResponseParseException {
      rethrow;
    } catch (e) {
      throw ResponseParseException('loadExtraFields: ${e.toString()}');
    }
  }

  Future<List<ValueModel>> loadQuestionsList(int topic) async {
    final result =
        BaseResponseRepository.fromMap((await rh.get<Map<String, dynamic>>(
      '/faq/form/questions/',
      queryParameters: <String, dynamic>{'topic': topic},
    ))
            .data!);

    try {
      return (result.data as List<dynamic>)
          .map(
            (dynamic item) => ValueModel.fromMap(item as Map<String, dynamic>),
          )
          .toList();
    } on ResponseParseException {
      rethrow;
    } catch (e) {
      throw ResponseParseException('loadExtraFields: ${e.toString()}');
    }
  }
}
