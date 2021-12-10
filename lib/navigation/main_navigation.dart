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
import 'package:bausch/sections/shops/shops_screen.dart';
import 'package:bausch/static/static_data.dart';
import 'package:flutter/material.dart';

//* Навигатор для страниц приложения
class MainNavigation extends StatelessWidget {
  const MainNavigation({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: Keys.mainContentNav,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        Widget page;

        switch (settings.name) {
          case '/':
            page = const LoaderScreen();
            break;

          case '/loading':
            page = const LoadingScreen();
            break;

          case '/home':
            page = const HomeScreen();
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
            page = const OrderRegistrationScreen();
            break;
          case '/shops':
            page = ShopsScreen();
            break;

          default:
            page = const HomeScreen();
        }
        return PageRouteBuilder<dynamic>(
          pageBuilder: (_, __, ___) => page,
          transitionsBuilder: (context, animation, anotherAnimation, child) {
            animation =
                CurvedAnimation(parent: animation, curve: Curves.easeInOutExpo);
            return SlideTransition(
              position: Tween(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: page,
            );
          },
        );
      },
    );
  }
}
