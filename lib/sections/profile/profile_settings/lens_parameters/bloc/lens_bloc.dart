import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/exceptions/success_false.dart';
import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/models/profile_settings/lens_parameters_model.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

part 'lens_event.dart';
part 'lens_state.dart';

class LensBloc extends Bloc<LensEvent, LensState> {
  LensBloc() : super(LensInitial()) {
    add(LensGet());
  }

  @override
  Stream<LensState> mapEventToState(LensEvent event) async* {
    if (event is LensUpdate) {
      yield LensUpdated(model: event.model);
    }

    if (event is LensGet) {
      yield LensGetting(model: state.model);
      yield await getParameters();
    }

    if (event is LensSend) {
      yield LensLoading(model: state.model);
      yield await sendParameters(event.model);
    }
  }

  Future<LensState> sendParameters(LensParametersModel model) async {
    final rh = RequestHandler();

    debugPrint('put ${model.diopter}, ${model.diopter}');

    try {
      // final parsedData =
      BaseResponseRepository.fromMap(
        (await rh.put<Map<String, dynamic>>(
          'user/lens/',
          data: FormData.fromMap(model.toMap()),
        ))
            .data!,
      );

      //debugPrint(parsedData.data.toString());

      return LensSuccess(model: model);
    } on ResponseParseException catch (e) {
      return LensFailed(
        title: 'Ошибка при обработке ответа от сервера',
        subtitle: e.toString(),
      );
    } on DioError catch (e) {
      return LensFailed(
        title: 'Ошибка при обработке ответа от сервера123',
        subtitle: e.toString(),
      );
    } on SuccessFalse catch (e) {
      return LensFailed(
        title: 'Ошибка при обработке ответа от сервера',
        subtitle: e.toString(),
      );
    }
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

      return LensGetSuccess(
        model: LensParametersModel.fromMap(
          parsedData.data as Map<String, dynamic>,
        ),
      );
    } on ResponseParseException catch (e) {
      return LensGetFailed(
        title: 'Ошибка при обработке ответа от сервера',
        subtitle: e.toString(),
        //model: state.model,
      );
    } on DioError catch (e) {
      return LensGetFailed(
        title: 'Ошибка при отправке запроса',
        subtitle: e.toString(),
        //model: state.model,
      );
    } on SuccessFalse catch (e) {
      return LensGetFailed(
        title: 'Ошибка при обработке ответа от сервера',
        subtitle: e.toString(),
        //model: state.model,
      );
    }
  }
}
