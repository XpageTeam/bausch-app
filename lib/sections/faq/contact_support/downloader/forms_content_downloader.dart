// ignore_for_file: avoid_catches_without_on_clauses, avoid_annotating_with_dynamic

import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/models/faq/forms/field_model.dart';
import 'package:bausch/models/faq/forms/value_model.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:dio/dio.dart';
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
      // return (result.data as List<dynamic>)
      //     .map((dynamic item) =>
      //         FieldModel.fromMap(item as Map<String, dynamic>))
      //     .toList();
      final list = (result.data as List<dynamic>)
          .map((dynamic item) =>
              FieldModel.fromMap(item as Map<String, dynamic>))
          .toList();
      debugPrint(list.toString());
      return list;
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
    } catch (e) {
      throw ResponseParseException('loadExtraFields: ${e.toString()}');
    }
  }

  Future<bool> sendData(
    String email,
    int topic,
    int question,
    String phone,
    String comment,
  ) async {
    BaseResponseRepository.fromMap((await rh.post<Map<String, dynamic>>(
      'faq/form/',
      data: FormData.fromMap(
        <String, dynamic>{
          'email': email,
          'topic': topic,
          'question': question,
          //'files': files,
        },
        //..addAll(extra),
      ),
    ))
        .data!);

    try {
      return true;
    } catch (e) {
      throw ResponseParseException('loadExtraFields: ${e.toString()}');
    }
  }
}
