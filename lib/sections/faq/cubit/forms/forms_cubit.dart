// ignore_for_file: avoid_annotating_with_dynamic

import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/exceptions/success_false.dart';
import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/models/faq/forms/field_model.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

part 'forms_state.dart';

class FormsCubit extends Cubit<FormsState> {
  FormsCubit() : super(FormsInitial()) {
    loadData();
  }

  Future<void> loadData() async {
    emit(FormsLoading());

    final rh = RequestHandler();

    try {
      final parsedData = BaseResponseRepository.fromMap(
        (await rh.get<Map<String, dynamic>>('faq/form/fields/')).data!,
      );

      emit(
        FormsSuccess(
          fields: (parsedData.data as List<dynamic>)
              .map((dynamic field) =>
                  FieldModel.fromMap(field as Map<String, dynamic>))
              .toList(),
        ),
      );
    } on ResponseParseException catch (e) {
      emit(
        FormsFailed(
          title: 'Ошибка при обработке ответа от сервера',
          subtitle: e.toString(),
        ),
      );
    } on DioError catch (e) {
      emit(
        FormsFailed(
          title: 'Ошибка при отправке запроса',
          subtitle: e.toString(),
        ),
      );
    } on SuccessFalse catch (e) {
      emit(
        FormsFailed(
          title: e.toString(),
        ),
      );
    }
  }
}
