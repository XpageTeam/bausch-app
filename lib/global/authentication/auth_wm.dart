import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/repositories/user/user_writer.dart';
import 'package:bausch/sections/auth/loading/loading_screen.dart';
import 'package:bausch/sections/home/home_screen.dart';
import 'package:bausch/sections/loader/loader_scren.dart';
import 'package:bausch/sections/registration/screens/city_email/city_and_email_screen.dart';
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
      : super(baseDependencies);

  @override
  void onLoad() {
    debugPrint('auth-load');
    super.onLoad();
  }

  @override
  void onBind() {
    debugPrint('auth-bind');

    subscribe(authStatus.stream, (value) {
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
      Keys.mainContentNav.currentState!.pushNamedAndRemoveUntil(
        targetPage,
        (route) => false,
      );
    });

    subscribe(checkAuthAction.stream, (value) {
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

    super.onBind();
  }
}
