import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/exceptions/success_false.dart';
import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/models/faq/forms/value_model.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

part 'values_event.dart';
part 'values_state.dart';

class ValuesBloc extends Bloc<ValuesEvent, ValuesState> {
  ValuesBloc() : super(ValuesInitial());

  @override
  Stream<ValuesState> mapEventToState(
    ValuesEvent event,
  ) async* {
    if (event is UpdateValues) {
      //debugPrint(event.id.toString());
      yield ValuesLoading();
      yield await loadData(event.id);
    }
  }

  Future<ValuesState> loadData(int id) async {
    final rh = RequestHandler();

    

    try {
      final parsedData = BaseResponseRepository.fromMap(
        (await rh.get<Map<String, dynamic>>(
          'faq/form/questions/',
          queryParameters: <String, dynamic>{'topic': id},
        ))
            .data!,
      );

      //debugPrint('topic is ${parsedData.data}');
      return ValuesSuccess(
        values: (parsedData.data as List<dynamic>)
            // ignore: avoid_annotating_with_dynamic
            .map((dynamic value) =>
                ValueModel.fromMap(value as Map<String, dynamic>))
            .toList(),
      );
    } on ResponseParseException catch (e) {
      return ValuesFailed(
        title: 'Ошибка при обработке ответа от сервера',
        subtitle: e.toString(),
      );
    } on DioError catch (e) {
      return ValuesFailed(
        title: 'Ошибка при отправке запроса',
        subtitle: e.toString(),
      );
    } on SuccessFalse catch (e) {
      return ValuesFailed(
        title: e.toString(),
      );
    }
  }
}
