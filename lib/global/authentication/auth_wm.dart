import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/repositories/user/user_writer.dart';
import 'package:bausch/static/static_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

enum AuthStatus {
  authenticated,
  unauthenticated,
  unknown,
}

class AuthWM extends WidgetModel {
  final authStatus = StreamedState<AuthStatus>(AuthStatus.unknown);

  // final user = EntityStreamedState<UserRepository>();

  final checkAuthAction = VoidAction();

  final UserWM userWM;

  AuthWM(WidgetModelDependencies baseDependencies, this.userWM)
      : super(baseDependencies) {
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
          // TODO(Danil): когда Гоша разберётся - сделать
          if (userWM.userData.value.data?.user.city == null ||
              userWM.userData.value.data?.user.email == null) {
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

      debugPrint(targetPage);
      debugPrint('context ${Keys.mainContentNav.currentState}');

      // if (Keys.mainContentNav.currentState != null) {
        Keys.mainContentNav.currentState!.pushNamedAndRemoveUntil(
          targetPage,
          (route) => false,
        );
      // }
    });

    checkAuthAction.bind((value) {
      if (userWM.userData.value.isLoading) return;

      userWM.userData.loading();

      UserWriter.checkUserToken().then((user) {
        if (user == null) {
          authStatus.accept(AuthStatus.unauthenticated);
          userWM.userData.error(Exception('Необходима авторизация'));
        } else {
          authStatus.accept(AuthStatus.authenticated);
          userWM.userData.content(user);
        }
      });
    });

    checkAuthAction();
  }
}
