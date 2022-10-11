// ignore_for_file: prefer_mixin

import 'dart:async';

import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:bausch/global/authentication/auth_wm.dart';
import 'package:bausch/global/login/login_wm.dart';
import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/navigation/app_router.dart';
import 'package:bausch/navigation/main_navigation.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mindbox/mindbox.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:surf_mwwm/surf_mwwm.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  Mindbox.instance.init(
    configuration: Configuration(
      domain: 'api.mindbox.ru',
      endpointIos: 'valeant-ios',
      endpointAndroid: 'valeant-android',
      subscribeCustomerIfCreated: true,
    ),
  );

  final analytics = FirebaseAnalytics.instance;

  AppsflyerSingleton();

  AndroidYandexMap.useAndroidViewSurface = false;

  runApp(
    MultiProvider(
      providers: [
        Provider<FirebaseAnalytics>.value(value: analytics),
        Provider<FirebaseAnalyticsObserver>.value(
          value: FirebaseAnalyticsObserver(analytics: analytics),
        ),
        Provider<AppsflyerSdk>.value(
          value: AppsflyerSingleton.sdk,
        ),
      ],
      child: MyApp(),
    ),
  );
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

class _MyAppState extends WidgetState<MyApp, AuthWM>
    with WidgetsBindingObserver {


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    wm.userWM.changeAppLifecycleStateAction(state);
  }

  @override
  void initState() {
    

    super.initState();
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
          navigatorObservers: [Provider.of<FirebaseAnalyticsObserver>(context)],
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
                defaultScale: true,
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

class AppsflyerSingleton {
  static final AppsflyerSingleton _singleton = AppsflyerSingleton._internal();
  static late AppsflyerSdk sdk;

  factory AppsflyerSingleton() {
    sdk = AppsflyerSdk(
      AppsFlyerOptions(
        afDevKey: 'tKZasDXefUEpQwds8CTvM3',
        appId: '1624464666',
        disableAdvertisingIdentifier: true,
      ),
    );

    sdk.initSdk();

    return _singleton;
  }
  AppsflyerSingleton._internal();
}
