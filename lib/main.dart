import 'package:bausch/global/authentication/auth_wm.dart';
import 'package:bausch/global/login/login_wm.dart';
import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/navigation/app_router.dart';
import 'package:bausch/navigation/main_navigation.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mindbox/mindbox.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final config = Configuration(
    domain: 'api.mindbox.ru',
    endpointIos: 'valeant-ios',
    endpointAndroid: 'valeant-android',
    subscribeCustomerIfCreated: true,
  );

  Mindbox.instance.init(configuration: config);
  runApp(MyApp());
}

class MyApp extends CoreMwwmWidget<AuthWM> {
  MyApp({
    Key? key,
  }) : super(
          widgetModelBuilder: (context) => AuthWM(UserWM()),
          key: key,
        );

  @override
  WidgetState<CoreMwwmWidget<AuthWM>, AuthWM> createWidgetState() =>
      _MyAppState();
}

class _MyAppState extends WidgetState<MyApp, AuthWM> {
  @override
  void initState() {
    super.initState();

    RequestHandler.setContext(context);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return OverlaySupport(
      toastTheme: ToastThemeData(
        background: AppTheme.mineShaft,
        textColor: Colors.white,
      ),
      child: MultiProvider(
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
        child: MaterialApp(
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
          onGenerateRoute: (settings) => AppRouter.generateRoute(
            settings,
            context,
            wm,
          ),
          theme: AppTheme.currentAppTheme,
          home: Builder(
            builder: (context) {
              return ResponsiveWrapper.builder(
                Provider(
                  create: (context) => LoginWM(
                    baseDependencies: const WidgetModelDependencies(),
                    context: context,
                  ),
                  lazy: false,
                  child: MainNavigation(
                    authWM: wm,
                  ),
                ),
                minWidth: 375,
                mediaQueryData: MediaQuery.of(context).copyWith(
                  textScaleFactor: 1.0,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
