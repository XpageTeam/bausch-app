import 'dart:async';
import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/exceptions/success_false.dart';
import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/repositories/user/user_writer.dart';
import 'package:bausch/sections/home/home_screen.dart';
import 'package:bausch/sections/profile/profile_screen.dart';
import 'package:bausch/sections/profile/profile_settings/profile_settings_screen.dart';
import 'package:bausch/sections/registration/registration_screen.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/widgets/error_page.dart';
import 'package:dio/dio.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
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

  late final FirebaseDynamicLinks dynamicLinks;
  late final PendingDynamicLinkData? initialLink;
  String? dynamicLink;
  bool isBinded = false;
  bool deepLinkingStarted = false;
  BuildContext? context;
  StreamSubscription<Uri>? _linkSubscription;
  AuthWM(this.userWM) : super(const WidgetModelDependencies()) {
    authStatus.bind((value) {
      // TODO(all): разобраться с bind'ом, он несколько раз тут вызывается
      if (!isBinded) {
        isBinded = true;
        dynamicLinks = FirebaseDynamicLinks.instance;
      }

      late String targetPage;

      switch (authStatus.value) {
        case AuthStatus.unknown:
          targetPage = '/';
          break;

        case AuthStatus.unauthenticated:
          targetPage = '/loading';
          break;

        case AuthStatus.authenticated:
          if (/*userWM.userData.value.data?.user.city == null ||*/
              userWM.userData.value.data?.user.email == null &&
                  userWM.userData.value.data?.user.pendingEmail == null) {
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
      _checkUserAuth();
    });
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  /// выход
  void logout() {
    userWM.logout();
    authStatus.accept(AuthStatus.unauthenticated);
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
      debugPrint('bannn$dynamicLinkData');
      final dynamicLink = await dynamicLinks.getDynamicLink(dynamicLinkData);
      debugPrint('bannnnn$dynamicLink');
      await dynamicLinksLogic(dynamicLink!);
    });
  }

  Future<void> initDynamicLinksAndroid(
    PendingDynamicLinkData? initialLinkAndroid,
  ) async {
    if (initialLinkAndroid != null) {
      if (authStatus.value == AuthStatus.authenticated) {
        debugPrint('мы с колд ссылки${initialLinkAndroid.link}');
        await dynamicLinksLogic(initialLinkAndroid);
      }
    }
    dynamicLinks.onLink.listen((pendingLink) async {
      debugPrint('мы с бэкграунд ссылки${pendingLink.link}');
      // TODO(info): для очистки зависающих ссылок, мб и не надо
      // print('ban' + (await dynamicLinks.getInitialLink())!.link.toString());
      await dynamicLinksLogic(pendingLink);
    });
  }

  Future dynamicLinksLogic(PendingDynamicLinkData dynamicLinkData) async {
    if (authStatus.value != AuthStatus.authenticated) {
      return;
    }

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

// TODO(all): не знаю как иначе сбрасывать этот навигационный трэш
    while (Keys.bottomNav.currentState != null &&
        Keys.bottomNav.currentState!.canPop()) {
      Keys.bottomNav.currentState!.pop();
    }
    while (Keys.mainNav.currentState != null &&
        Keys.mainNav.currentState!.canPop()) {
      Keys.mainNav.currentState!.pop();
    }

    while (Keys.mainContentNav.currentState != null &&
        Keys.mainContentNav.currentState!.canPop()) {
      Keys.mainContentNav.currentState!.pop();
    }
    await Future.delayed(Duration(seconds: 1));
    if (dynamicLink == '/user_profile' || dynamicLink == '/user_settings') {
      await Navigator.push(
        Keys.mainContentNav.currentContext!,
        MaterialPageRoute(
          builder: (context) {
            return page;
          },
        ),
      );
    } else {
      await Navigator.pushReplacement(
        Keys.mainContentNav.currentContext!,
        MaterialPageRoute(
          builder: (context) {
            return page;
          },
        ),
      );
    }

    dynamicLink = null;
  }

  Future<void> _checkUserAuth() async {
    if (userWM.userData.value.isLoading) return;
    await userWM.userData.loading();
    try {
      final user = await UserWriter.checkUserToken();

      if (user == null) {
        await authStatus.accept(AuthStatus.unauthenticated);
        // TODO(all): обдумать поведение этой ситуации
        await userWM.userData.error(Exception('неавторизован'));
        if (Platform.isIOS) {
          CupertinoPageRoute<void>(builder: (context) {
            return const RegistrationScreen();
          });
        } else {
          MaterialPageRoute<void>(builder: (context) {
            return const RegistrationScreen();
          });
        }
      } else {
        await userWM.userData.content(user);
        await authStatus.accept(AuthStatus.authenticated);
        if (!deepLinkingStarted) {
          deepLinkingStarted = true;
          initialLink = await dynamicLinks.getInitialLink();

          await initDynamicLinksAndroid(initialLink);
        }
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        await authStatus.accept(AuthStatus.unauthenticated);
        await userWM.userData.error(Exception('Необходима авторизация'));

        return;
      }
      await userWM.userData.error(
        CustomException(
          title: 'При отправке запроса произошла ошибка',
          subtitle: e.toString(),
          ex: e,
        ),
      );
    } on ResponseParseException catch (e) {
      await userWM.userData.error(
        CustomException(
          title: 'При обработке овтета от сервера произошла ошибка',
          subtitle: e.toString(),
          ex: e,
        ),
      );
    } on SuccessFalse catch (e) {
      await userWM.userData.error(
        CustomException(
          title: e.toString(),
          ex: e,
        ),
      );
    }

    if (userWM.userData.value.hasError &&
        userWM.userData.value.error.toString() != 'Exception: неавторизован') {
      // TODO(all): ошибка не воспринимается как кастом экзепшн
      // final error = userWM.userData.value.error as CustomException;

      final error = userWM.userData.value.error;

      if (context != null) {
        await Navigator.of(context!).pushAndRemoveUntil<void>(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              // return ErrorPage(
              //   title: error.title,
              //   subtitle: error.subtitle,
              //   buttonCallback: checkAuthAction,
              //   buttonText: 'Обновить',
              // );
              return ErrorPage(
                title: error.toString(),
                buttonCallback: checkAuthAction,
                buttonText: 'Обновить',
              );
            },
          ),
          (route) => false,
        );
      } else {
        if (Keys.mainContentNav.currentContext != null) {
          await Navigator.of(context!).pushAndRemoveUntil<void>(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
                // return ErrorPage(
                //   title: error.title,
                //   subtitle: error.subtitle,
                //   buttonCallback: checkAuthAction,
                //   buttonText: 'Обновить',
                // );
                return ErrorPage(
                  title: error.toString(),
                  buttonCallback: checkAuthAction,
                  buttonText: 'Обновить',
                );
              },
            ),
            (route) => false,
          );
        }
      }
    }
  }
}
