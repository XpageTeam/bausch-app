import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/exceptions/success_false.dart';
import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/models/profile_settings/lens_parameters_model.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

part 'get_lens_state.dart';

class GetLensCubit extends Cubit<GetLensState> {
  GetLensCubit() : super(GetLensInitial()) {
    getParameters();
  }

  Future<void> getParameters() async {
    final rh = RequestHandler();

    try {
      final parsedData = BaseResponseRepository.fromMap(
        (await rh.get<Map<String, dynamic>>(
          'user/lens/',
        ))
            .data!,
      );

      emit(GetLensSuccess(
        model: LensParametersModel.fromMap(
          parsedData.data as Map<String, dynamic>,
        ),
      ));
    } on ResponseParseException catch (e) {
      emit(GetLensFailed(
        title: 'Ошибка при обработке ответа от сервера',
        subtitle: e.toString(),
      ));
    } on DioError catch (e) {
      emit(GetLensFailed(
        title: 'Ошибка при обработке ответа от сервера',
        subtitle: e.toString(),
      ));
    } on SuccessFalse catch (e) {
      emit(GetLensFailed(
        title: 'Ошибка при обработке ответа от сервера',
        subtitle: e.toString(),
      ));
    }
  }
}
