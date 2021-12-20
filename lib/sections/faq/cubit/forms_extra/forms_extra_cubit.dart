import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/models/faq/forms/field_model.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:bausch/sections/faq/bloc/forms_extra/forms_extra_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';

//part 'forms_extra_state.dart';

class FormsExtraCubit extends Cubit<FormsExtraState> {
  FormsExtraCubit() : super(FormsExtraInitial()) {
    loadData();
  }

  Future<void> loadData() async {
    emit(FormsExtraLoading());

    final rh = RequestHandler();

    try {
      final parsedData = BaseResponseRepository.fromMap(
        (await rh.get<Map<String, dynamic>>(
          'faq/form/fields/extra/',
          queryParameters: <String, dynamic>{'question': 1},
        ))
            .data!,
      );

      emit(
        FormsExtraSuccess(
          fields: (parsedData.data as List<dynamic>)
              // ignore: avoid_annotating_with_dynamic
              .map((dynamic field) =>
                  FieldModel.fromMap(field as Map<String, dynamic>))
              .toList(),
        ),
      );
    } on ResponseParseException catch (e) {
      emit(
        FormsExtraFailed(
          title: 'Ошибка при обработке ответа от сервера',
          subtitle: e.toString(),
        ),
      );
    } on DioError catch (e) {
      emit(
        FormsExtraFailed(
          title: 'Ошибка при отправке запроса',
          subtitle: e.toString(),
        ),
      );
    }
  }
}
