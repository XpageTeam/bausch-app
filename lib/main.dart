import 'package:bausch/global/authentication/auth_wm.dart';
import 'package:bausch/global/login/login_wm.dart';
import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/navigation/main_navigation.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

void main() {
  runApp(MyApp());
}

/*
class MyApp extends CoreMwwmWidget<AuthWM> {
  MyApp({
    Key? key,
  }) : super(
          widgetModelBuilder: (context) => AuthWM(
            const WidgetModelDependencies(),
            UserWM(),
          ),
          key: key,
        );

  @override
  WidgetState<CoreMwwmWidget<AuthWM>, AuthWM> createWidgetState() =>
      _MyAppState();
}
*/
class MyApp extends StatelessWidget {
  final wm = AuthWM(
    const WidgetModelDependencies(),
    UserWM(),
  );

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );

    return OverlaySupport(
      toastTheme: ToastThemeData(
        background: AppTheme.mineShaft,
        textColor: Colors.white,
      ),
      child: Provider(
        create: (context) => wm.userWM,
        child: ScreenUtilInit(
          designSize: const Size(375, 799),
          builder: () => MaterialApp(
            supportedLocales: const [
              Locale('ru', ''),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            title: 'Bausch + Lomb',
            navigatorKey: Keys.mainNav,
            theme: AppTheme.currentAppTheme,
            home: Builder(
              builder: (context) {
                return MultiProvider(
                  providers: [
                    Provider(
                      create: (context) {
                        return wm.userWM;
                      },
                      lazy: false,
                    ),
                    Provider(
                      create: (context) {
                        return wm;
                      },
                      lazy: false,
                    ),
                  ],
                  child: Builder(builder: (context) {
                    RequestHandler.setContext(context);
                    
                    return Provider(
                      create: (context) => LoginWM(
                        baseDependencies: const WidgetModelDependencies(),
                        context: context,
                      ),
                      lazy: false,
                      child: const MainNavigation(),
                    );
                  }),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
