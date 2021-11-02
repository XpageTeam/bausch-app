// ignore_for_file: avoid_dynamic_calls

import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/models/user/user_repository.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  String? message;
  LoginBloc() : super(const LoginInitial());

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginSetPhone) {
      yield LoginPhoneSetted(
        phone: event.phone,
        isPhoneValid: event.isPhoneValid,
      );
    }

    if (event is LoginSendPhone) {
      yield LoginPhoneSending(phone: event.phone);
      yield await _sendPhone(event.phone);
    }
  }

  Future<LoginState> _sendPhone(String phone) async {
    final rh = RequestHandler();

    try {
      final result = await UserRepository.sendPhone(phone);

      if (result.success) {
        //message = (result.data as Map<String, dynamic>)['message'] as String;
        var data =
            Map<String, dynamic>.from(result.data as Map<String, dynamic>);
        debugPrint(data.toString());
        return LoginPhoneSended(phone: phone);
      } else {
        return LoginFailed(
          title: result.message ?? 'Не удалось отправить телефон',
          phone: phone,
        );
      }
    } on ResponseParseExeption catch (e) {
      return LoginFailed(
        title: 'Не удалось обработать ответ от сервера',
        phone: phone,
        subtitle: e.toString(),
      );
    } on DioError catch (e) {
      return LoginFailed(
        title: 'При отправке телефона произошла ошибка',
        phone: phone,
        subtitle: '${e.response?.statusCode} ${e.response?.statusMessage}',
      );
    }
  }
}
