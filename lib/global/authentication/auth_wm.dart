import 'package:bausch/repositories/user/user_repository.dart';
import 'package:bausch/repositories/user/user_writer.dart';
import 'package:bausch/sections/auth/loading/loading_screen.dart';
import 'package:bausch/sections/home/home_screen.dart';
import 'package:bausch/sections/loader/loader_scren.dart';
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

  final user = EntityStreamedState<UserRepository>();

  final checkAuthAction = VoidAction();

  AuthWM(WidgetModelDependencies baseDependencies) : super(baseDependencies);

  @override
  void onLoad() {
    debugPrint('auth-load');
    super.onLoad();
  }

  @override
  void onBind() {
    debugPrint('auth-bind');

    subscribe(authStatus.stream, (value) {
      late Widget targetPage;

      switch (authStatus.value) {
        case AuthStatus.unknown:
          targetPage = const LoaderScreen();
          break;

        case AuthStatus.unauthenticated:
          targetPage =  const LoadingScreen();
          break;

        case AuthStatus.authenticated:
          // TODO(Danil): реализовать переход
          // if (user.value.data != null) {
          //   if (user.value.data?.user.city != null) {
          targetPage = const HomeScreen();
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

      Navigator.of(Keys.mainNav.currentContext!).pushAndRemoveUntil(
        PageRouteBuilder<void>(
          pageBuilder: (context, animation, secondaryAnimation) {
            return targetPage;
          },
        ),
        (route) => false,
      );
    });

    subscribe(checkAuthAction.stream, (value) {
      if (user.value.isLoading) return;

      user.loading();

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
      // ignore: argument_type_not_assignable_to_error_handler
      });
    });

    checkAuthAction();

    super.onBind();
  }
}
