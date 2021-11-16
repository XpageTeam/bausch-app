import 'dart:io';

import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

part 'fields_event.dart';
part 'fields_state.dart';

class FieldsBloc extends Bloc<FieldsEvent, FieldsState> {
  FieldsBloc() : super(FieldsInitial()) {
    debugPrint('Q: ${state.question}, topic: ${state.topic}');
  }

  @override
  Stream<FieldsState> mapEventToState(
    FieldsEvent event,
  ) async* {
    if (event is FieldsSend) {
      yield FieldsSending(
        email: state.email,
        topic: state.topic,
        question: state.question,
        files: state.files,
        extra: state.extra,
      );
      yield await _sendFields(
        event.email,
        event.topic,
        event.question,
        event.files,
        event.extra,
      );
    }

    if (event is FieldsSetEmail) {
      debugPrint(event.txt);
      yield FieldsUpdated(
        email: event.txt,
        topic: state.topic,
        question: state.question,
        files: state.files,
        extra: state.extra,
      );
    }

    if (event is FieldsAddFiles) {
      debugPrint(event.files.toString());
      yield FieldsUpdated(
        email: state.email,
        topic: state.topic,
        question: state.question,
        files: event.files,
        extra: state.extra,
      );
    }

    if (event is FieldsSetTopic) {
      //debugPrint(event.number.toString());
      yield FieldsUpdated(
        email: state.email,
        topic: event.number,
        question: state.question,
        files: state.files,
        extra: state.extra,
      );
    }

    if (event is FieldsSetQuestion) {
      //debugPrint(event.number.toString());
      yield FieldsUpdated(
        email: state.email,
        topic: state.topic,
        question: event.number,
        files: state.files,
        extra: state.extra,
      );
    }

    if (event is FieldsAddExtra) {
      yield _addExtra(event.extra);
      debugPrint(state.extra.toString());
    }
  }

  FieldsState _addExtra(Map<String, dynamic> extra) {
    if (extra.keys.isNotEmpty) {
      if (!state.extra.containsKey(extra.keys.first)) {
        state.extra.addAll(extra);
      } else {
        state.extra[extra.keys.first] = extra.values.first;
      }
    } else {
      if (state.extra.isNotEmpty) {
        state.extra.remove(state.extra.keys.last);
      }
    }
    return FieldsUpdated(
      email: state.email,
      topic: state.topic,
      question: state.question,
      files: state.files,
      extra: state.extra,
    );
  }

  Future<FieldsState> _sendFields(
    String email,
    int topic,
    int question,
    List<File> files,
    Map<String, dynamic> extra,
  ) async {
    final rh = RequestHandler();

    try {
      final parsedData =
          BaseResponseRepository.fromMap((await rh.post<Map<String, dynamic>>(
        'faq/form/',
        data: FormData.fromMap(
          <String, dynamic>{
            'email': email,
            'topic': topic,
            'question': question,
            'files': files,
          }..addAll(extra),
        ),
      ))
              .data!);

      if (parsedData.success) {
        //message = (result.data as Map<String, dynamic>)['message'] as Strin
        debugPrint('sended');
        return FieldsSended(
          email: state.email,
          topic: state.topic,
          question: state.question,
          files: state.files,
          extra: state.extra,
        );
      } else {
        debugPrint(parsedData.message);
        return FieldsFailed(
          title: parsedData.message ?? 'Что-то пошло не так',
          email: state.email,
          topic: state.topic,
          question: state.question,
          files: state.files,
          extra: state.extra,
        );
      }
    } on ResponseParseExeption catch (e) {
      return FieldsFailed(
        title: 'Не удалось обработать ответ от сервера',
        subtitle: e.toString(),
        email: state.email,
        topic: state.topic,
        question: state.question,
        files: state.files,
        extra: state.extra,
      );
    } on DioError catch (e) {
      return FieldsFailed(
        title: 'Не удалось обработать ответ от сервера',
        subtitle: e.toString(),
        email: state.email,
        topic: state.topic,
        question: state.question,
        files: state.files,
        extra: state.extra,
      );
    }
  }
}
