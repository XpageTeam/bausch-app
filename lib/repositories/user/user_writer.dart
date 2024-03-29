import 'dart:convert';

import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/models/user/user_model/subscription_model.dart';
import 'package:bausch/models/user/user_model/user.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:bausch/repositories/user/user_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserWriter {
  /// Если в [SharedPreferences] записан пользователя - он будет возвращён этим методом
  static Future<UserRepository?> checkUserToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final userToken = prefs.getString('userToken');

      if (userToken == null) {
        return null;
      }

      return await getUserFromServer(userToken);
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  static Future<void> removeUser() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('userToken');
  }

  static Future<void> writeToken(String token) async {
    final prefs = await SharedPreferences.getInstance();

    debugPrint(token);

    await prefs.setString('userToken', token);
  }

  static Future<UserRepository> getUserFromServer(String token) async {
    final rh = RequestHandler();

    final res = await rh.get<Map<String, dynamic>>(
      '/user/',
      options: Options(
        headers: <String, dynamic>{
          'x-api-key': token,
        },
      ),
    );
    // TODO(info): тут смотрим что приходит пользователю
    // print('что пришло' + res.data.toString());

    final parsed =
        BaseResponseRepository.fromMap(res.data as Map<String, dynamic>);

    final repo = UserRepository.fromJson(parsed.data! as Map<String, dynamic>);

    // TODO(Danil): тупое место для подмешивания токена
    return repo.copyWith(
      user: repo.user.copyWith(
        token: token,
      ),
    );
  }

  /// Метод обновления данных пользователя в mindbox
  /// Не вызывать напрямую! Для изменения данных использовать [UserWM]
  static Future<UserRepository> updateUserData(User userData) async {
    final rh = RequestHandler();

    final result =
        BaseResponseRepository.fromMap((await rh.put<Map<String, dynamic>>(
      '/user/',
      data: FormData.fromMap(<String, dynamic>{
        'firstName': userData.name,
        'lastName': userData.lastName,
        'middleName': userData.secondName,
        'email': userData.email,
        'birthDate': userData.birthDate?.toIso8601String(),
        'city': userData.city,
      }),
    ))
            .data!);

    final updatedUser =
        UserRepository.fromJson(result.data as Map<String, dynamic>);

    // TODO(Danil): опять тупое место для подмешивания токена
    return UserRepository(
      balance: updatedUser.balance,
      user: updatedUser.user.copyWith(
        token: userData.token,
      ),
    );
  }

  static Future sendUpdateNotification({
    required List<SubscriptionModel> notifications,
  }) async {
    try {
      final rh = RequestHandler();
      final json = jsonEncode(notifications);

      await rh.post<Map<String, dynamic>>(
        '/user/subscriptions/',
        data: FormData.fromMap(<String, dynamic>{
          'subscriptions': json,
        }),
      );
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      throw ResponseParseException('Ошибка в sendUpdateNotification: $e');
    }
  }
}
