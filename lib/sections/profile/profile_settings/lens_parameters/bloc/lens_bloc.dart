import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/exceptions/success_false.dart';
import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/models/profile_settings/lens_parameters_model.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

part 'lens_event.dart';
part 'lens_state.dart';

class LensBloc extends Bloc<LensEvent, LensState> {
  LensBloc() : super(LensInitial()) {
    on<LensEvent>((event, emit) {
      // TODO: implement event handler
    });
  }

  //* Не закончил
  Future<LensState> getParameters() async {
    final rh = RequestHandler();

    try {
      final parsedData = BaseResponseRepository.fromMap(
        (await rh.get<Map<String, dynamic>>(
          'user/lens',
        ))
            .data!,
      );

      return LensGotten(
        cylinder: state.cylinder,
        addict: state.addict,
        axis: state.axis,
        diopter: state.diopter,
      );
    } on ResponseParseException catch (e) {
      return LensFailed(
        title: 'Ошибка при обработке ответа от сервера',
        subtitle: e.toString(),
        cylinder: state.cylinder,
        addict: state.addict,
        axis: state.axis,
        diopter: state.diopter,
      );
    } on DioError catch (e) {
      return LensFailed(
        title: 'Ошибка при отправке запроса',
        subtitle: e.toString(),
        cylinder: state.cylinder,
        addict: state.addict,
        axis: state.axis,
        diopter: state.diopter,
      );
    } on SuccessFalse catch (e) {
      return LensFailed(
        title: 'Ошибка при обработке запроса',
        subtitle: e.toString(),
        cylinder: state.cylinder,
        addict: state.addict,
        axis: state.axis,
        diopter: state.diopter,
      );
    }
  }

  //* Не закончил
  Future<LensState> sendParameters() async {
    final rh = RequestHandler();

    try {
      final parsedData = BaseResponseRepository.fromMap(
        (await rh.put<Map<String, dynamic>>(
          'user/lens',
        ))
            .data!,
      );

      return LensGotten(
        cylinder: state.cylinder,
        addict: state.addict,
        axis: state.axis,
        diopter: state.diopter,
      );
    } on ResponseParseException catch (e) {
      return LensFailed(
        title: 'Ошибка при обработке ответа от сервера',
        subtitle: e.toString(),
        cylinder: state.cylinder,
        addict: state.addict,
        axis: state.axis,
        diopter: state.diopter,
      );
    } on DioError catch (e) {
      return LensFailed(
        title: 'Ошибка при отправке запроса',
        subtitle: e.toString(),
        cylinder: state.cylinder,
        addict: state.addict,
        axis: state.axis,
        diopter: state.diopter,
      );
    } on SuccessFalse catch (e) {
      return LensFailed(
        title: 'Ошибка при обработке запроса',
        subtitle: e.toString(),
        cylinder: state.cylinder,
        addict: state.addict,
        axis: state.axis,
        diopter: state.diopter,
      );
    }
  }
}
