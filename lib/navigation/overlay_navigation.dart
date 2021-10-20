import 'package:bausch/models/sheet_model.dart';
import 'package:bausch/sections/sheets/screens/consultation/consultation_screen.dart';
import 'package:bausch/sections/sheets/screens/discount_online/discount_online_screen.dart';
import 'package:bausch/sections/sheets/screens/discount_optics/discount_optics_screen.dart';
import 'package:bausch/sections/sheets/screens/discount_optics/discount_verification.dart';
import 'package:bausch/sections/sheets/screens/discount_optics/final_discount_optics.dart';
import 'package:bausch/sections/sheets/screens/free_packaging/free_packaging_screen.dart';
import 'package:bausch/sections/sheets/screens/parners/partners_screen.dart';
import 'package:bausch/sections/sheets/screens/webinars/final_webinar.dart';
import 'package:bausch/sections/sheets/screens/webinars/webinar_verification.dart';
import 'package:bausch/sections/sheets/screens/webinars/webinars_screen.dart';
import 'package:bausch/sections/sheets/sheet_screen.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/test/models.dart';
import 'package:flutter/material.dart';

class OverlayNavigation extends StatelessWidget {
  final ScrollController controller;
  final SheetModel sheetModel;
  const OverlayNavigation({
    required this.sheetModel,
    required this.controller,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: Keys.bottomSheetNav,
      initialRoute:
          sheetModel.type == SheetType.consultations ? '/consultation' : '/',
      onGenerateRoute: (settings) {
        Widget page;

        switch (settings.name) {
          case '/':
            page = SheetScreen(model: sheetModel, controller: controller);
            break;

          case '/consultation':
            page = ConsultationScreen(
              controller: controller,
              model: Models.items[2],
            );
            break;

          case '/free_packaging':
            page = FreePackagingScreen(
              controller: controller,
              model: Models.items[2],
            );
            break;

          case '/discount_optics':
            page = DiscountOpticsScreen(
              controller: controller,
              model: Models.items[2],
            );
            break;

          case '/discount_online':
            page = DiscountOnlineScreen(
              controller: controller,
              model: Models.items[2],
            );
            break;

          case '/partners':
            page = PartnersScreen(
              controller: controller,
              model: Models.items[2],
            );
            break;

          case '/webinar':
            page = WebinarsScreen(
              controller: controller,
              model: Models.items[2],
            );
            break;

          case '/verification_discount':
            page = DiscountVerification(
              controller: controller,
              model: Models.items[2],
            );
            break;

          case '/verification_webinar':
            page = WebinarVerification(
              controller: controller,
              model: Models.items[2],
            );
            break;

          case '/final_webinar':
            page = FinalWebinar(
              controller: controller,
              model: Models.items[2],
            );
            break;

          case '/final_discount':
            page = FinalDiscountOptics(
              controller: controller,
              model: Models.items[2],
            );
            break;

          case '/final_free_packaging':
            page = FinalWebinar(
              controller: controller,
              model: Models.items[2],
            );
            break;

          default:
            page =
                SheetScreen(model: Models.sheets.first, controller: controller);
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