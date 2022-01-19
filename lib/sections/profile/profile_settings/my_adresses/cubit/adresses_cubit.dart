import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/exceptions/success_false.dart';
import 'package:bausch/models/profile_settings/adress_model.dart';
import 'package:bausch/sections/order_registration/downloader/address_downloader.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

part 'adresses_state.dart';

class AdressesCubit extends Cubit<AdressesState> {
  final _downloader = AddressDownloader();

  AdressesCubit() : super(AdressesInitial()) {
    getAdresses();
  }

  Future<void> getAdresses() async {
    emit(AdressesLoading());

    try {
      emit(
        GetAdressesSuccess(
          adresses: await _downloader.loadData(),
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
