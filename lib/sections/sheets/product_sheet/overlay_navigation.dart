import 'package:bausch/models/catalog_item_model.dart';
import 'package:bausch/models/sheet_model.dart';
import 'package:bausch/sections/sheets/product_sheet/product_sheet_screen.dart';
import 'package:bausch/sections/sheets/sheet_screen.dart';
import 'package:bausch/test/models.dart';
import 'package:flutter/material.dart';
import 'package:bausch/static/static_data.dart';

class OverlayNavigation extends StatelessWidget {
  final ScrollController controller;
  final SheetModel sheetModel;
  const OverlayNavigation(
      {required this.sheetModel, required this.controller, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: Utils.bottomSheetNav,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        Widget page;

        switch (settings.name) {
          case '/':
            page = Sheet(model: sheetModel, controller: controller);
            break;
          case '/product':
            page = ProductSheet(
              controller: controller,
              model: (settings.arguments as ProductSheetArguments).model,
            );
            break;
          default:
            page = Sheet(model: Models.sheets.first, controller: controller);
        }
        return PageRouteBuilder(
            pageBuilder: (_, __, ___) => page,
            transitionsBuilder: (context, animation, anotherAnimation, child) {
              animation = CurvedAnimation(
                  parent: animation, curve: Curves.easeInOutExpo);
              return SlideTransition(
                position: Tween(
                  begin: const Offset(1.0, 0.0),
                  end: const Offset(0.0, 0.0),
                ).animate(animation),
                child: page,
              );
            });
      },
    );
  }
}
