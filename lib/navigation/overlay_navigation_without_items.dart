import 'package:bausch/models/sheets/base_catalog_sheet_model.dart';
import 'package:bausch/models/sheets/folder/sheet_without_items_model.dart';
import 'package:bausch/sections/sheets/screens/add_points/add_points_details.dart';
import 'package:bausch/sections/sheets/screens/add_points/add_points_screen.dart';
import 'package:bausch/sections/sheets/screens/add_points/final_add_points.dart';
import 'package:bausch/sections/sheets/screens/consultation/consultation_screen.dart';
import 'package:bausch/sections/sheets/screens/consultation/consultation_verification.dart';
import 'package:bausch/sections/sheets/screens/consultation/final_consultation.dart';
import 'package:bausch/sections/sheets/screens/program/program_screen.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/test/models.dart';
import 'package:flutter/material.dart';

//* Навигатор для bottomSheet'а без элементов каталога
class OverlayNavigationWithoutItems extends StatelessWidget {
  final ScrollController controller;
  final BaseCatalogSheetModel model;
  const OverlayNavigationWithoutItems({
    required this.controller,
    required this.model,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: Keys.bottomSheetWithoutItemsNav,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        Widget page;

        switch (settings.name) {
          case '/':
            if (model.type == StaticData.types['consultation']) {
              page = ConsultationScreen(
                controller: controller,
              );
            } else {
              page = AddPointsScreen(
                controller: controller,
              );
            }
            break;

          case '/consultation':
            page = ConsultationScreen(
              controller: controller,
            );
            break;

          case '/program':
            page = ProgramScreen(controller: controller);
            break;

          case '/addpoints_details':
            page = AddPointsDetails(
              model: Models.addItems[0],
              controller: controller,
            );
            break;

          case '/verification_consultation':
            page = ConsultationVerification(
              controller: controller,
              model: Models.items[2],
            );
            break;

          case '/final_consultation':
            page = FinalConsultation(
              controller: controller,
              model: Models.items[2],
            );
            break;

          case '/final_addpoints':
            page = FinalAddPointsScreen(
              controller: controller,
            );
            break;

          default:
            page = Container();
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
