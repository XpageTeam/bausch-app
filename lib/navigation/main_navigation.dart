// ignore_for_file: avoid_annotating_with_dynamic

import 'dart:io';

import 'package:after_layout/after_layout.dart';
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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//* Навигатор для страниц приложения
class MainNavigation extends StatefulWidget {
  final AuthWM authWM;

  const MainNavigation({
    required this.authWM,
    Key? key,
  }) : super(key: key);

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation>
    with AfterLayoutMixin<MainNavigation> {
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
                showAnimation = false;
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
}
