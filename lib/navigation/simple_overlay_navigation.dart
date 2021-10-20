import 'package:bausch/models/sheets/simple_sheet_model.dart';
import 'package:bausch/sections/faq/faq_screen.dart';
import 'package:bausch/static/static_data.dart';
import 'package:flutter/material.dart';

//* Навигатор для bottomSheet'а без элементов каталога
class SimpleOverlayNavigation extends StatelessWidget {
  final ScrollController controller;
  final SimpleSheetModel sheetModel;

  const SimpleOverlayNavigation({
    required this.controller,
    required this.sheetModel,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: Keys.simpleBottomSheetNav,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        Widget page;

        switch (settings.name) {
          case '/':
            if (sheetModel.type == SimpleSheetType.faq) {
              page = FaqScreen(
                controller: controller,
              );
            } else {
              page = Container();
            }
            break;

          case '/faq':
            page = FaqScreen(controller: controller);
            break;

          default:
            page = Container();
            break;
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
