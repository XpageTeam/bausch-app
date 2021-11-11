import 'package:bausch/repositories/user/user_repository.dart';
import 'package:bausch/repositories/user/user_writer.dart';
import 'package:bausch/sections/home/home_screen.dart';
import 'package:bausch/sections/loader/loader_scren.dart';
import 'package:bausch/sections/loading/loading_screen.dart';
import 'package:bausch/sections/registration/city_and_email_screen.dart';
import 'package:bausch/static/static_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

enum AuthStatus {
  authenticated,
  unauthenticated,
  unknown,
}

/// TODO Отображать ошибки
class AuthWM extends WidgetModel {
  final authStatus = StreamedState<AuthStatus>(AuthStatus.unknown);

  final user = EntityStreamedState<UserRepository>()..loading();

  final checkAuthAction = VoidAction();

  AuthWM(WidgetModelDependencies baseDependencies) : super(baseDependencies);

  @override
  void onBind() {
    subscribe(authStatus.stream, (value) {
      switch (authStatus.value) {
        case AuthStatus.unknown:
          Navigator.of(Keys.mainNav.currentContext!).pushAndRemoveUntil(
            PageRouteBuilder<void>(
              pageBuilder: (context, animation, secondaryAnimation) {
                return const LoaderScreen();
              },
            ),
            (route) => false,
          );
          break;

        case AuthStatus.unauthenticated:
          Navigator.of(Keys.mainNav.currentContext!).pushAndRemoveUntil(
            PageRouteBuilder<void>(
              pageBuilder: (context, animation, secondaryAnimation) {
                return const LoadingScreen();
              },
            ),
            (route) => false,
          );
          break;

        case AuthStatus.authenticated:
        // TODO(Danil): реализовать переход
          // if (user.value.data != null) {
          //   if (user.value.data?.user.city != null) {
              Navigator.of(Keys.mainNav.currentContext!).pushAndRemoveUntil(
                CupertinoPageRoute<void>(
                  builder: (context) => const HomeScreen(),
                ),
                (route) => false,
              );
          //   } else {
          //     Navigator.of(Keys.mainNav.currentContext!).pushAndRemoveUntil(
          //       CupertinoPageRoute<void>(
          //         builder: (context) => const CityAndEmailScreen(),
          //       ),
          //       (route) => false,
          //     );
          //   }
          // }

          break;
      }
    });

    subscribe(checkAuthAction.stream, (value) {
      user.loading();

      debugPrint('21342');

      UserWriter.checkUserToken().then((user) {
        if (user == null) {
          authStatus.accept(AuthStatus.unauthenticated);
          this.user.error(
                Exception('Необходима авторизация'),
              );
        } else {
          authStatus.accept(AuthStatus.authenticated);
          this.user.content(user);
        }

        debugPrint(user.toString());
      });
    });

    super.onBind();
  }
}
