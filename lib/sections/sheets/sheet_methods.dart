import 'package:bausch/models/sheets/base_catalog_sheet_model.dart';
import 'package:bausch/models/sheets/folder/sheet_without_items_model.dart';
import 'package:bausch/models/sheets/folder/simple_sheet_model.dart';
import 'package:bausch/navigation/overlay_navigation_with_items.dart';
import 'package:bausch/navigation/overlay_navigation_without_items.dart';
import 'package:bausch/navigation/simple_overlay_navigation.dart';
import 'package:bausch/sections/sheets/sheet.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';

//* Функция вывода bottomSheet с эементами каталога
void showSheetWithItems(BuildContext context, BaseCatalogSheetModel model) {
  showFlexibleBottomSheet<void>(
    useRootNavigator: true,
    minHeight: 0,
    initHeight: 0.9, //calculatePercentage(model.models!.length),
    maxHeight: 0.95,
    anchors: [0, 0.6, 0.95],
    context: context,
    builder: (context, controller, d) {
      return SheetWidget(
        child: OverlayNavigationWithItems(
          sheetModel: model,
          controller: controller,
        ),
      );
    },
  );
}

//* Функция вывода bottomSheet(Частые вопросы,Библиотека ссылок,Правила прграммы)
void showSimpleSheet(BuildContext context, SimpleSheetModel model) {
  showFlexibleBottomSheet<void>(
    useRootNavigator: true,
    minHeight: 0,
    initHeight: 0.95,
    maxHeight: 0.95,
    anchors: [0, 0.6, 0.95],
    context: context,
    builder: (context, controller, d) {
      return SheetWidget(
        child: SimpleOverlayNavigation(
          controller: controller,
          sheetModel: model,
        ),
      );
    },
  );
}

//* Функция вывода bottomSheet без элементов каталога
void showSheetWithoutItems(BuildContext context, SheetModelWithoutItems model) {
  showFlexibleBottomSheet<void>(
    useRootNavigator: true,
    minHeight: 0,
    isCollapsible: false,
    initHeight: 0.95,
    maxHeight: 0.95,
    anchors: [0, 0.6, 0.95],
    context: context,
    builder: (context, controller, d) {
      return SheetWidget(
        child: OverlayNavigationWithoutItems(
          sheetModel: model,
          controller: controller,
        ),
      );
    },
  );
}

//* Расчёт высоты, на которую откроется bottomSheet в процентах (от 0 до 1)
//* Расчёт в зависимтсти от количества элементов каталога
double calculatePercentage(int lenght) {
  switch (lenght ~/ 2) {
    case 1:
      return 0.5;
    case 2:
      return 0.8;
    default:
      return 0.9;
  }
}
