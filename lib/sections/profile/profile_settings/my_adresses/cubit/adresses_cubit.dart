import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/exceptions/success_false.dart';
import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/models/profile_settings/adress_model.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

part 'adresses_state.dart';

class AdressesCubit extends Cubit<AdressesState> {
  AdressesCubit() : super(AdressesInitial()) {
    getAdresses();
  }

  Future<void> getAdresses() async {
    emit(AdressesLoading());

    final rh = RequestHandler();

    try {
      final parsedData = BaseResponseRepository.fromMap(
        (await rh.get<Map<String, dynamic>>(
          '/user/addresses/',
        ))
            .data!,
      );

      emit(
        GetAdressesSuccess(
          adresses: (parsedData.data as List<dynamic>)
              // ignore: avoid_annotating_with_dynamic
              .map((dynamic address) =>
                  AdressModel.fromMap(address as Map<String, dynamic>))
              .toList(),
        ),
      );
    } on ResponseParseException catch (e) {
      emit(AdressesFailed(
        title: 'Ошибка при обработке ответа от сервера',
        subtitle: e.toString(),
      ));
    } on DioError catch (e) {
      emit(AdressesFailed(
        title: 'Ошибка при отправке запроса',
        subtitle: e.toString(),
      ));
    } on SuccessFalse catch (e) {
      emit(AdressesFailed(
        title: e.toString(),
      ));
    }
  }
}
