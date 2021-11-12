import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

part 'fields_event.dart';
part 'fields_state.dart';

class FieldsBloc extends Bloc<FieldsEvent, FieldsState> {
  FieldsBloc() : super(const FieldsInitial()) {
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
      );
      yield await _sendFields(
        event.email,
        event.topic,
        event.question,
      );
    }

    if (event is FieldsSetEmail) {
      debugPrint(event.txt);
      yield FieldsUpdated(
        email: event.txt,
        topic: state.topic,
        question: state.question,
      );
    }

    if (event is FieldsSetTopic) {
      //debugPrint(event.number.toString());
      yield FieldsUpdated(
        email: state.email,
        topic: event.number,
        question: state.question,
      );
    }

    if (event is FieldsSetQuestion) {
      //debugPrint(event.number.toString());
      yield FieldsUpdated(
        email: state.email,
        topic: state.topic,
        question: event.number,
      );
    }
  }

  Future<FieldsState> _sendFields(String email, int topic, int question) async {
    final rh = RequestHandler();

    try {
      final parsedData =
          BaseResponseRepository.fromMap((await rh.post<Map<String, dynamic>>(
        'faq/form/',
        data: FormData.fromMap(<String, dynamic>{
          'email': email,
          'topic': topic,
          'question': question,
        }),
      ))
              .data!);

      if (parsedData.success) {
        //message = (result.data as Map<String, dynamic>)['message'] as Strin
        debugPrint('sended');
        return FieldsSended(
          email: state.email,
          topic: state.topic,
          question: state.question,
        );
      } else {
        debugPrint(parsedData.message);
        return FieldsFailed(
          title: parsedData.message ?? 'Что-то пошло не так',
          email: state.email,
          topic: state.topic,
          question: state.question,
        );
      }
    } on ResponseParseExeption catch (e) {
      return FieldsFailed(
        title: 'Не удалось обработать ответ от сервера',
        subtitle: e.toString(),
        email: state.email,
        topic: state.topic,
        question: state.question,
      );
    } on DioError catch (e) {
      return FieldsFailed(
        title: 'Не удалось обработать ответ от сервера',
        subtitle: e.toString(),
        email: state.email,
        topic: state.topic,
        question: state.question,
      );
    }
  }
}
