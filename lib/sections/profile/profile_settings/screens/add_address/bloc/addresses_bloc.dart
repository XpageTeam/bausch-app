import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/exceptions/success_false.dart';
import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/models/profile_settings/adress_model.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

part 'addresses_event.dart';
part 'addresses_state.dart';

class AddressesBloc extends Bloc<AddressesEvent, AddressesState> {
  // AddressesBloc() : super(AddressesInitial()) {
  //   on<AddressesSend>((event, emit) => sendAddress(event.address));
  //   on<AddressesDelete>((event, emit) => deleteAddress(event.id));
  // }

  AddressesBloc() : super(AddressesInitial());

  @override
  Stream<AddressesState> mapEventToState(AddressesEvent event) async* {
    if (event is AddressesSend) {
      yield await sendAddress(event.address);
    }

    if (event is AddressesDelete) {
      yield await deleteAddress(event.id);
    }

    if (event is AddressUpdate) {
      yield await updateAddress(event.address);
    }
  }

  Future<AddressesState> sendAddress(AdressModel address) async {
    final rh = RequestHandler();

    try {
      final parsedData = BaseResponseRepository.fromMap(
        (await rh.post<Map<String, dynamic>>(
          '/user/address/',
          data: address.toMap(),
        ))
            .data!,
      );

      debugPrint(parsedData.data.toString());

      return AddressesSended();
    } on ResponseParseException catch (e) {
      return AddressesFailed(
        title: 'Ошибка при обработке ответа от сервера',
        subtitle: e.toString(),
      );
    } on DioError catch (e) {
      return AddressesFailed(
        title: 'Ошибка при отправке запроса',
        subtitle: e.toString(),
      );
    } on SuccessFalse catch (e) {
      return AddressesFailed(
        title: 'Ошибка при обработке запроса',
        subtitle: e.toString(),
      );
    }
  }

  Future<AddressesState> deleteAddress(int id) async {
    final rh = RequestHandler();

    try {
      // final parsedData = 
      BaseResponseRepository.fromMap(
        (await rh.delete<Map<String, dynamic>>(
          'user/address/$id/',
        ))
            .data!,
      );

      return AddressesSended();
    } on ResponseParseException catch (e) {
      return AddressesFailed(
        title: 'Ошибка при обработке ответа от сервера',
        subtitle: e.toString(),
      );
    } on DioError catch (e) {
      return AddressesFailed(
        title: 'Ошибка при отправке запроса',
        subtitle: e.toString(),
      );
    } on SuccessFalse catch (e) {
      return AddressesFailed(
        title: 'Ошибка при обработке запроса',
        subtitle: e.toString(),
      );
    }
  }

  Future<AddressesState> updateAddress(AdressModel address) async {
    final rh = RequestHandler();

    try {
      final parsedData = BaseResponseRepository.fromMap(
        (await rh.put<Map<String, dynamic>>(
          '/user/address/${address.id}/',
          data: FormData.fromMap(address.toMap()),
        ))
            .data!,
      );

      debugPrint(parsedData.data.toString());

      return AddressesSended();
    } on ResponseParseException catch (e) {
      return AddressesFailed(
        title: 'Ошибка при обработке ответа от сервера',
        subtitle: e.toString(),
      );
    } on DioError catch (e) {
      return AddressesFailed(
        title: 'Ошибка при отправке запроса',
        subtitle: e.toString(),
      );
    } on SuccessFalse catch (e) {
      return AddressesFailed(
        title: 'Ошибка при обработке запроса',
        subtitle: e.toString(),
      );
    }
  }
}
