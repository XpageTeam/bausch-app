import 'dart:io';

import 'package:bausch/global/authentication/auth_wm.dart';
import 'package:bausch/navigation/main_navigation.dart';
import 'package:bausch/sections/order_registration/address_select_screen.dart';
import 'package:bausch/sections/order_registration/order_address_screen.dart';
import 'package:bausch/sections/profile/profile_settings/my_adresses/my_adresses_screen.dart';
import 'package:bausch/sections/profile/profile_settings/screens/add_address/add_adress_details_screen.dart';
import 'package:bausch/sections/profile/profile_settings/screens/add_address/add_adress_screen.dart';
import 'package:bausch/widgets/loader/animated_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static Route<dynamic> generateRoute(
    RouteSettings settings,
    BuildContext context,
    AuthWM authWM,
  ) {
    final path = settings.name!.split('/');

    Widget targetPage = const Scaffold(
      body: Center(
        child: AnimatedLoader(),
      ),
    );

    if (settings.name == '/') {
      targetPage = MainNavigation(
        authWM: authWM,
      );
    }

    if (settings.name == '/my_adresses') {
      targetPage = const MyAdressesScreen();
    }

    if (settings.name == '/add_adress') {
      targetPage = const AddAdressScreen();
    }

    if (settings.name == '/add_details') {
      targetPage = AddDetailsScreen(
        adress: (settings.arguments as AddDetailsArguments).adress,
        isFirstLaunch:
            (settings.arguments as AddDetailsArguments).isFirstLaunch,
      );
    }

    if (settings.name == '/order_address') {
      targetPage = OrderAddressScreen(
        adress: (settings.arguments as OrderAddressScreenArguments).adress,
      );
    }

    if (settings.name == '/address_select') {
      targetPage = AddressSelectScreen(
        userAdresses:
            (settings.arguments as AddressSelectScreenArguments).userAdresses,
      );
    }

    if (Platform.isAndroid) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => targetPage,
      );
    } else {
      return CupertinoPageRoute<dynamic>(
        builder: (context) => targetPage,
      );
    }
  }
}
