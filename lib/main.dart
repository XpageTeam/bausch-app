import 'package:bausch/global/authentication/auth_wm.dart';
import 'package:bausch/global/global_providers.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:bausch/sections/auth/loading/loading_screen.dart';
import 'package:bausch/sections/home/home_screen.dart';
import 'package:bausch/sections/loader/loader_scren.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends CoreMwwmWidget<AuthWM> {
  MyApp({
    // required AuthWM wm,
    Key? key,
  }) : super(
          widgetModelBuilder: (context) =>
              AuthWM(const WidgetModelDependencies()),
          key: key,
        );

  @override
  WidgetState<CoreMwwmWidget<AuthWM>, AuthWM> createWidgetState() =>
      _MyAppState();
}

class _MyAppState extends WidgetState<MyApp, AuthWM> {
  @override
  Widget build(BuildContext context) {
    RequestHandler.setContext(context);

    wm.checkAuthAction();

    return Provider(
      create: (context) => wm,
      child: GlobalProviders(
        child: MaterialApp(
          title: 'Bausch + Lomb',
          navigatorKey: Keys.mainNav,
          theme: AppTheme.currentAppTheme,
          home: StreamedStateBuilder<AuthStatus>(
            streamedState: wm.authStatus,
            builder: (context, data) {
              switch (data) {
                case AuthStatus.unknown:
                  return const LoaderScreen();

                case AuthStatus.unauthenticated:
                  return const LoadingScreen();

                case AuthStatus.authenticated:
                  // TODO(Danil): реализовать переход
                  // if (wm.user.value.data?.user.city != null) {
                    return const HomeScreen();
                  // } else {
                  //   return const CityAndEmailScreen();
                  // }
              }
            },
          ),
        ),
      ),
    );
  }
}
