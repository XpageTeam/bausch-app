import 'package:bausch/models/sheets/sheet_with_items_model.dart';
import 'package:bausch/models/sheets/sheet_without_items_model.dart';
import 'package:bausch/models/sheets/simple_sheet_model.dart';
import 'package:bausch/navigation/overlay_navigation_with_items.dart';
import 'package:bausch/navigation/overlay_navigation_without_items.dart';
import 'package:bausch/navigation/simple_overlay_navigation.dart';
import 'package:bausch/sections/sheets/sheet.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';

//* Функция вывода bottomSheet с эементами каталога
void showSheetWithItems(BuildContext context, SheetModelWithItems model) {
  showFlexibleBottomSheet<void>(
    useRootNavigator: true,
    minHeight: 0,
    initHeight: calculatePercentage(model.models!.length),
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

// void showSimpleSheet(BuildContext context, SimpleSheetModel model) {
//   showModalBottomSheet<void>(
//     elevation: 0,
//     useRootNavigator: true,
//     context: context,
//     backgroundColor: Colors.transparent,
//     isScrollControlled: true,
//     builder: (context) {
//       return SheetWidget(
//         child: SimpleOverlayNavigation(
//           controller: ScrollController(),
//           sheetModel: model,
//         ),
//       );
//     },
//   );
// }

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
