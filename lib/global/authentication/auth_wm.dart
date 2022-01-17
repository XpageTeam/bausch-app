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
          if (userWM.userData.value.data?.user.city == null ||
              (userWM.userData.value.data?.user.email == null &&
                  userWM.userData.value.data?.user.pendingEmail == null)) {
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
  }

  /// выход
  void logout() {
    userWM.logout();
    authStatus.accept(AuthStatus.unauthenticated);
  }
}
