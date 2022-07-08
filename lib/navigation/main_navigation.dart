// ignore_for_file: avoid_annotating_with_dynamic

import 'dart:async';
import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:app_links/app_links.dart';
import 'package:bausch/global/authentication/auth_wm.dart';
import 'package:bausch/help/utils.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:bausch/sections/auth/loading/loading_screen.dart';
import 'package:bausch/sections/home/home_screen.dart';
import 'package:bausch/sections/loader/loader_scren.dart';
import 'package:bausch/sections/order_registration/order_registration_screen.dart';
import 'package:bausch/sections/profile/profile_screen.dart';
import 'package:bausch/sections/profile/profile_settings/lens_parameters/lenses_parameters.dart';
import 'package:bausch/sections/profile/profile_settings/my_adresses/my_adresses_screen.dart';
import 'package:bausch/sections/profile/profile_settings/profile_settings_screen.dart';
import 'package:bausch/sections/profile/profile_settings/screens/add_address/add_adress_details_screen.dart';
import 'package:bausch/sections/profile/profile_settings/screens/add_address/add_adress_screen.dart';
import 'package:bausch/sections/profile/profile_settings/screens/city/city_screen.dart';
import 'package:bausch/sections/registration/code_screen.dart';
import 'package:bausch/sections/registration/registration_screen.dart';
import 'package:bausch/sections/registration/screens/city_email/city_and_email_screen.dart';
import 'package:bausch/static/static_data.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//* Навигатор для страниц приложения
class MainNavigation extends StatefulWidget {
  final AuthWM authWM;

  const MainNavigation({required this.authWM, Key? key}) : super(key: key);

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation>
    with AfterLayoutMixin<MainNavigation> {
  late final FirebaseDynamicLinks dynamicLinks;
  late final PendingDynamicLinkData? initialLink;
  String? dynamicLink;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    dynamicLinks = FirebaseDynamicLinks.instance;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initialLink = await dynamicLinks.getInitialLink();
      if (Platform.isIOS) {
        await initDynamicLinksIOS();
        // await initDynamicLinksAndroid(initialLink);
      } else {
        //  await initDynamicLinksIOS();
        await initDynamicLinksAndroid(initialLink);
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await Keys.mainContentNav.currentState!.maybePop();
        return false;
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Utils.unfocus(context);
        },
        child: Navigator(
          key: Keys.mainContentNav,
          requestFocus: false,
          initialRoute: '/',
          onPopPage: (route, dynamic settings) {
            Utils.unfocus(context);
            return false;
          },
          onGenerateRoute: (settings) {
            Widget page;
            var showAnimation = true;

            Utils.unfocus(context);

            switch (settings.name) {
              case '/':
                page = const LoaderScreen();
                break;

              case '/loading':
                page = const LoadingScreen();
                showAnimation = false;
                break;

              case '/city_and_email':
                page = CityAndEmailScreen();
                showAnimation = false;
                break;

              case '/registration':
                page = const RegistrationScreen();
                showAnimation = false;
                break;

              case '/code':
                page = const CodeScreen();
                break;

              case '/profile':
                page = ProfileScreen();
                break;

              case '/profile_settings':
                page = ProfileSettingsScreen();
                break;

              case '/my_adresses':
                page = const MyAdressesScreen();
                break;

              case '/city':
                page = CityScreen();
                break;

              case '/lenses_parameters':
                page = const LensesParametersScreen();
                break;

              case '/add_details':
                page = AddDetailsScreen(
                  adress: (settings.arguments as AddDetailsArguments).adress,
                  isFirstLaunch:
                      (settings.arguments as AddDetailsArguments).isFirstLaunch,
                );
                break;

              case '/add_adress':
                page = const AddAdressScreen();
                break;

              case '/order_registration':
                page = OrderRegistrationScreen(
                  model:
                      (settings.arguments as OrderRegistrationScreenArguments)
                          .model,
                );
                break;

              // case '/shops':
              //   page = SelectOpticScreen();
              //   break;

              case '/home':
              default:
                page = HomeScreen();
                showAnimation = false;
            }

            if (showAnimation) {
              if (Platform.isIOS) {
                return CupertinoPageRoute<void>(builder: (context) {
                  return page;
                });
              } else {
                return MaterialPageRoute<void>(builder: (context) {
                  return page;
                });
              }
            } else {
              return PageRouteBuilder<void>(
                pageBuilder: (context, animation, secondaryAnimation) {
                  return page;
                },
              );
            }

            // return PageRouteBuilder<dynamic>(
            //   pageBuilder: (_, __, ___) => page,
            //   transitionsBuilder: (context, animation, anotherAnimation, child) {
            //     animation =
            //         CurvedAnimation(parent: animation, curve: Curves.easeInOutExpo);
            //     return SlideTransition(
            //       position: Tween(
            //         begin: const Offset(1.0, 0.0),
            //         end: Offset.zero,
            //       ).animate(animation),
            //       child: page,
            //     );
            //   },
            // );
          },
        ),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    void authStart() {
      debugPrint('authStart');

      if (Keys.mainContentNav.currentContext != null) {
        RequestHandler.setContext(context);
        widget.authWM.context = Keys.mainContentNav.currentContext;
        widget.authWM.checkAuthAction();
      } else {
        debugPrint('authRestart');
        Future.delayed(const Duration(milliseconds: 50), authStart);
      }
    }

    authStart();
  }

  Future<void> initDynamicLinksIOS() async {
    //   await Future.delayed(const Duration(seconds: 1));
    final appLinks = AppLinks();

    //   // Check initial link if app was in cold state (terminated)
    //   final appLink = await appLinks.getInitialAppLink();
    //   if (appLink != null) {
    //    debugPrint('bannn' + appLink.toString());
    //     final dynamicLink = await dynamicLinks.getDynamicLink(appLink);
    //     debugPrint('bannnnn' + dynamicLink.toString());
    //     if(dynamicLink != null)
    //     await dynamicLinksLogic(dynamicLink!);
    //   }

    //   // Handle link when app is in warm state (front or background)
    _linkSubscription = appLinks.uriLinkStream.listen((dynamicLinkData) async {
      debugPrint('bannn' + dynamicLinkData.toString());
      final dynamicLink = await dynamicLinks.getDynamicLink(dynamicLinkData);
      debugPrint('bannnnn' + dynamicLink.toString());
      await dynamicLinksLogic(dynamicLink!);
    });
  }

  Future<void> initDynamicLinksAndroid(
    PendingDynamicLinkData? initialLinkAndroid,
  ) async {
    if (initialLinkAndroid != null) {
      debugPrint('мы с колд ссылки' + initialLinkAndroid.link.toString());
      await dynamicLinksLogic(initialLinkAndroid);
      // ignore: parameter_assignments

    }
    dynamicLinks.onLink.listen((pendingLink) async {
      await dynamicLinksLogic(pendingLink);
    });
  }

  Future dynamicLinksLogic(PendingDynamicLinkData dynamicLinkData) async {
    debugPrint('мы с бэкграунд ссылки' + dynamicLinkData.link.toString());
    dynamicLink = dynamicLinkData.link.queryParameters.values.first;
    Widget page;
    switch (dynamicLink) {
      case '/user_profile':
        page = ProfileScreen();
        break;
      case '/user_settings':
        page = ProfileSettingsScreen();
        break;
      case '/add_points':
        page = HomeScreen(
          dynamicLink: '/add_points',
        );
        break;
      case '/program':
        page = HomeScreen(
          dynamicLink: '/program',
        );
        break;
      case '/faq':
        page = HomeScreen(
          dynamicLink: '/faq',
        );
        break;
      case '/faq_form':
        page = HomeScreen(
          dynamicLink: '/faq_form',
        );
        break;
      case '/stories':
        page = HomeScreen(
          dynamicLink: '/stories',
        );
        break;
      case '/webinars':
        page = HomeScreen(
          dynamicLink: '/webinars',
        );
        break;
      case '/discount_optics':
        page = HomeScreen(
          dynamicLink: '/discount_optics',
        );
        break;
      case '/discount_online':
        page = HomeScreen(
          dynamicLink: '/discount_online',
        );
        break;
      case '/partners':
        page = HomeScreen(
          dynamicLink: '/partners',
        );
        break;
      default:
        page = HomeScreen();
    }
    dynamicLink = null;

    // TODO(all): послу пуша бесконечная загрузка, нужно нажимать назад
    // если приложение уже было запущено, то приложение откроется поверх предыдущей навигации
    //
    await Navigator.push<void>(
      Keys.mainContentNav.currentContext!,
      MaterialPageRoute(
        builder: (context) {
          return page;
        },
      ),
    );
  }
}
