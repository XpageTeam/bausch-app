// ignore_for_file: avoid_catches_without_on_clauses

import 'dart:async';

import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/exceptions/success_false.dart';
import 'package:bausch/models/user/user_model/subscription_model.dart';
import 'package:bausch/models/user/user_model/user.dart';
import 'package:bausch/repositories/user/user_repository.dart';
import 'package:bausch/repositories/user/user_writer.dart';
import 'package:bausch/widgets/default_notification.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class UserWM extends WidgetModel {
  final updateUserDataAction = VoidAction();

  final userData = EntityStreamedState<UserRepository>();

  final changeAppLifecycleStateAction = StreamedAction<AppLifecycleState>();

  bool canUpdate = true;

  Timer? updateTimer;

  UserWM() : super(const WidgetModelDependencies()) {
    updateUserDataAction.bind((_) {
      reloadUserData();
    });

    subscribe<AppLifecycleState>(
      changeAppLifecycleStateAction.stream,
      _changeAppLifecycleState,
    );

    updateTimer = Timer.periodic(
      const Duration(minutes: 5),
      (timer) {
        if (canUpdate) {
          updateUserDataAction();
        }
      },
    );
  }

  @override
  void dispose() {
    updateTimer?.cancel();

    super.dispose();
  }

  /// Метод изменения данных пользователя
  /// обработка и отображение ошибок уже содержатся в нём
  Future<bool> updateUserData(
    User userData, {
    List<SubscriptionModel>? notifications,
    String? successMessage,
    bool showMessage = true,
  }) async {
    CustomException? ex;

    try {
      if (notifications != null) {
        await UserWriter.sendUpdateNotification(
          notifications: notifications,
        );
      }
      final newUserData = await UserWriter.updateUserData(userData);

      await this.userData.content(newUserData);

      if (showMessage) {
        showDefaultNotification(
          title: successMessage ?? 'Данные успешно обновлены',
          success: true,
        );
      }

      return true;
    } on DioError catch (e) {
      ex = CustomException(
        title: 'При отправке запроса произошла ошибка',
        subtitle: e.message,
        ex: e,
      );
    } on ResponseParseException catch (e) {
      ex = CustomException(
        title: 'При обработке ответа от сервера произошла ошибка',
        subtitle: e.toString(),
        ex: e,
      );
    } on SuccessFalse catch (e) {
      ex = CustomException(
        title: e.toString(),
        ex: e,
      );
    }

    showTopError(ex);

    return false;
  }

  Future<void> logout() async {
    await UserWriter.removeUser();
  }

  Future<bool> reloadUserData() async {
    if (!canUpdate) return false;

    try {
      final userRepo = await UserWriter.checkUserToken();

      if (userRepo != null) {
        await userData.content(userRepo);
      }
    } catch (e) {
      debugPrint('Закгрузка пользователя: $e');
    }

    return true;
  }

  void _changeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        canUpdate = true;
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        canUpdate = false;
        break;
    }
  }
}
