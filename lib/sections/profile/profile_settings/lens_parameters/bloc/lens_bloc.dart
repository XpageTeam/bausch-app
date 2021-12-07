import 'dart:convert';

import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/exceptions/success_false.dart';
import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/models/profile_settings/lens_parameters_model.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

part 'lens_event.dart';
part 'lens_state.dart';

class LensBloc extends Bloc<LensEvent, LensState> {
  LensBloc() : super(LensInitial()) {
    on<LensGet>((event, emit) => getParameters());
  }

  Future<LensState> getParameters() async {
    final rh = RequestHandler();

    try {
      final parsedData = BaseResponseRepository.fromMap(
        (await rh.get<Map<String, dynamic>>(
          'user/lens/',
        ))
            .data!,
      );

      debugPrint(parsedData.data.toString());

      return LensGotten(
        model: LensParametersModel.fromMap(
          parsedData.data as Map<String, dynamic>,
        ),
      );
    } on ResponseParseException catch (e) {
      return LensFailed(
        title: 'Ошибка при обработке ответа от сервера',
        subtitle: e.toString(),
      );
    } on DioError catch (e) {
      return LensFailed(
        title: 'Ошибка при отправке запроса',
        subtitle: e.toString(),
      );
    } on SuccessFalse catch (e) {
      return LensFailed(
        title: 'Ошибка при обработке запроса',
        subtitle: e.toString(),
      );
    }
  }
}
