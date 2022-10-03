import 'dart:io';

import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/exceptions/success_false.dart';
import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/repositories/user/user_writer.dart';
import 'package:bausch/sections/registration/registration_screen.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/widgets/error_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

enum AuthStatus {
  authenticated,
  unauthenticated,
  unknown,
}

// TODO(all): при авторизации может выпасть ошибка НЕДОСТАТОЧНО ПРАВ
// не понятно почему (возможно не тот код)
class AuthWM extends WidgetModel {
  final authStatus = StreamedState<AuthStatus>(AuthStatus.unknown);
  final checkAuthAction = VoidAction();
  final UserWM userWM;

  BuildContext? context;

  AuthWM(this.userWM) : super(const WidgetModelDependencies()) {
    authStatus.bind((value) {
      late String targetPage;

      switch (authStatus.value) {
        case AuthStatus.unknown:
          targetPage = '/';
          break;

        case AuthStatus.unauthenticated:
          targetPage = '/loading';
          break;

        case AuthStatus.authenticated:
          if (/*userWM.userData.value.data?.user.city == null ||*/
              userWM.userData.value.data?.user.email == null &&
                  userWM.userData.value.data?.user.pendingEmail == null) {
            targetPage = '/city_and_email';
          } else {
            targetPage = '/home';
          }

          break;
      }

      // Keys.mainContentNav.currentState!.pushAndRemoveUntil(
      //   PageRouteBuilder<void>(
      //     pageBuilder: (context, animation, secondaryAnimation) {
      //       return targetPage;
      //     },
      //   ),
      //   (route) => false,
      // );

      // debugPrint(targetPage);
      debugPrint('context в авторизации: $context');

      if (context != null) {
        Navigator.of(context!).pushNamedAndRemoveUntil(
          targetPage,
          (route) => false,
        );
      } else if (Keys.mainContentNav.currentContext != null) {
        Navigator.of(Keys.mainContentNav.currentContext!)
            .pushNamedAndRemoveUntil(
          targetPage,
          (route) => false,
        );
      }
    });

    checkAuthAction.bind((value) {
      _checkUserAuth();
    });
  }

  /// выход
  void logout() {
    userWM.logout();
    authStatus.accept(AuthStatus.unauthenticated);
  }

  Future<void> _checkUserAuth() async {
    if (userWM.userData.value.isLoading) return;

    await userWM.userData.loading();

    try {
      final user = await UserWriter.checkUserToken();

      if (user == null) {
        await authStatus.accept(AuthStatus.unauthenticated);
        // TODO(all): обдумать поведение этой ситуации
        await userWM.userData.error(Exception('Необходима авторизация'));
        if (Platform.isIOS) {
          CupertinoPageRoute<void>(builder: (context) {
            return const RegistrationScreen();
          });
        } else {
          MaterialPageRoute<void>(builder: (context) {
            return const RegistrationScreen();
          });
        }
      } else {
        await userWM.userData.content(user);
        await authStatus.accept(AuthStatus.authenticated);
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        await authStatus.accept(AuthStatus.unauthenticated);
        await userWM.userData.error(Exception('Необходима авторизация'));

        return;
      }
      await userWM.userData.error(
        CustomException(
          title: 'При отправке запроса произошла ошибка',
          subtitle: e.toString(),
          ex: e,
        ),
      );
    } on ResponseParseException catch (e) {
      await userWM.userData.error(
        CustomException(
          title: 'При обработке овтета от сервера произошла ошибка',
          subtitle: e.toString(),
          ex: e,
        ),
      );
    } on SuccessFalse catch (e) {
      await userWM.userData.error(
        CustomException(
          title: e.toString(),
          ex: e,
        ),
      );
    }

    if (userWM.userData.value.hasError &&
        userWM.userData.value.error.toString() !=
            'Exception: Необходима авторизация') {
      // TODO(all): ошибка не воспринимается как кастом экзепшн
      // final error = userWM.userData.value.error as CustomException;
      final error = userWM.userData.value.error;

      if (context != null) {
        await Navigator.of(context!).pushAndRemoveUntil<void>(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              // return ErrorPage(
              //   title: error.title,
              //   subtitle: error.subtitle,
              //   buttonCallback: checkAuthAction,
              //   buttonText: 'Обновить',
              // );
              return ErrorPage(
                title: error.toString(),
                buttonCallback: checkAuthAction,
                buttonText: 'Обновить',
              );
            },
          ),
          (route) => false,
        );
      } else {
        if (Keys.mainContentNav.currentContext != null) {
          await Navigator.of(context!).pushAndRemoveUntil<void>(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
                // return ErrorPage(
                //   title: error.title,
                //   subtitle: error.subtitle,
                //   buttonCallback: checkAuthAction,
                //   buttonText: 'Обновить',
                // );
                return ErrorPage(
                  title: error.toString(),
                  buttonCallback: checkAuthAction,
                  buttonText: 'Обновить',
                );
              },
            ),
            (route) => false,
          );
        }
      }
    }
  }
}
