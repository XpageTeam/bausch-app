// ignore_for_file: avoid_annotating_with_dynamic

import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/exceptions/success_false.dart';
import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/models/faq/forms/field_model.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

part 'forms_extra_event.dart';
part 'forms_extra_state.dart';

class FormsExtraBloc extends Bloc<FormsExtraEvent, FormsExtraState> {
  FormsExtraBloc() : super(FormsExtraInitial()) {
    on<FormsExtraEvent>((event, emit) async {
      if (event is FormsExtraChangeId) {
        debugPrint(event.id.toString());
        emit(FormsExtraLoading());
        emit(await loadData(event.id));
      }
    });
  }
  Future<FormsExtraState> loadData(int id) async {
    //FormsExtraLoading();

    final rh = RequestHandler();

    try {
      final parsedData = BaseResponseRepository.fromMap(
        (await rh.get<Map<String, dynamic>>(
          'faq/form/fields/extra/',
          queryParameters: <String, dynamic>{'question': id},
        ))
            .data!,
      );

      return FormsExtraSuccess(
        fields: (parsedData.data as List<dynamic>)
            .map((dynamic field) =>
                FieldModel.fromMap(field as Map<String, dynamic>))
            .toList(),
      );
    } on ResponseParseException catch (e) {
      return FormsExtraFailed(
        title: 'Ошибка при обработке ответа от сервера',
        subtitle: e.toString(),
      );
    } on DioError catch (e) {
      return FormsExtraFailed(
        title: 'Ошибка при отправке запроса',
        subtitle: e.toString(),
      );
      // ignore: unused_catch_clause
    } on SuccessFalse catch (e) {
      return const FormsExtraFailed(
        title: 'что-то пошло не так',
      );
    }
  }
}

// class FormsExtraBloc extends Bloc<FormsExtraEvent, FormsExtraState> {
//   FormsExtraBloc() : super(FormsExtraInitial());

//   @override
//   Stream<FormsExtraState> mapEventToState(
//     FormsExtraEvent event,
//   ) async* {
//     if (event is FormsExtraChangeId) {
//       debugPrint(event.id.toString());
//       yield FormsExtraLoading();
//       yield await loadData(event.id);
//     }
//   }

//   Future<FormsExtraState> loadData(int id) async {
//     //FormsExtraLoading();

//     final rh = RequestHandler();

//     try {
//       final parsedData = BaseResponseRepository.fromMap(
//         (await rh.get<Map<String, dynamic>>(
//           'faq/form/fields/extra/',
//           queryParameters: <String, dynamic>{'question': id},
//         ))
//             .data!,
//       );

//       return FormsExtraSuccess(
//         fields: (parsedData.data as List<dynamic>)
//             .map((dynamic field) =>
//                 FieldModel.fromMap(field as Map<String, dynamic>))
//             .toList(),
//       );
//     } on ResponseParseException catch (e) {
//       return FormsExtraFailed(
//         title: 'Ошибка при обработке ответа от сервера',
//         subtitle: e.toString(),
//       );
//     } on DioError catch (e) {
//       return FormsExtraFailed(
//         title: 'Ошибка при отправке запроса',
//         subtitle: e.toString(),
//       );
//       // ignore: unused_catch_clause
//     } on SuccessFalse catch (e) {
//       return FormsExtraFailed(
//         title: 'что-то пошло не так',
//       );
//     }
//   }
// }
