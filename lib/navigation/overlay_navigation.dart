import 'package:bausch/models/sheets/sheet_model.dart';
import 'package:bausch/sections/sheets/screens/add_points/add_points_screen.dart';
import 'package:bausch/sections/sheets/screens/consultation/consultation_screen.dart';
import 'package:bausch/sections/sheets/screens/consultation/consultation_verification.dart';
import 'package:bausch/sections/sheets/screens/consultation/final_consultation.dart';
import 'package:bausch/sections/sheets/screens/program/program_screen.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/test/models.dart';
import 'package:flutter/material.dart';

class OverlayNavigation extends StatelessWidget {
  final ScrollController controller;
  final SheetModel sheetModel;
  const OverlayNavigation({
    required this.controller,
    required this.sheetModel,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: Keys.bottomSheetNav,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        Widget page;

        switch (settings.name) {
          case '/':
            if (sheetModel.type == SheetType.consultation) {
              page = ConsultationScreen(
                controller: controller,
                model: Models.items[2],
              );
            } else if (sheetModel.type == SheetType.program) {
              page = ProgramScreen(controller: controller);
            } else {
              page = AddPointsScreen(
                controller: controller,
              );
            }
            break;

          case '/consultation':
            page = ConsultationScreen(
              controller: controller,
              model: Models.items[2],
            );
            break;

          case '/program':
            page = ProgramScreen(controller: controller);
            break;

          case '/addpoints':
            page = ConsultationScreen(
              controller: controller,
              model: Models.items[2],
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
