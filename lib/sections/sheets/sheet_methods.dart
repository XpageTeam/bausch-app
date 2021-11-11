import 'package:another_flushbar/flushbar.dart';
import 'package:bausch/models/catalog_item/catalog_item_model.dart';
import 'package:bausch/models/faq/topic_model.dart';
import 'package:bausch/models/sheets/base_catalog_sheet_model.dart';
import 'package:bausch/models/sheets/folder/simple_sheet_model.dart';
import 'package:bausch/navigation/overlay_navigation_with_items.dart';
import 'package:bausch/navigation/overlay_navigation_without_items.dart';
import 'package:bausch/navigation/simple_overlay_navigation.dart';
import 'package:bausch/sections/loader/widgets/animated_loader.dart';
import 'package:bausch/sections/sheets/sheet.dart';
import 'package:bausch/sections/sheets/widgets/listeners/sheet_listener.dart';
import 'package:bausch/sections/sheets/widgets/providers/sheet_providers.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';

//* Функция вывода bottomSheet с эементами каталога
void showSheetWithItems(
  BuildContext context,
  BaseCatalogSheetModel model,
  List<CatalogItemModel> items,
) {
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
          items: items,
        ),
      );
    },
  );
}

//* Функция вывода bottomSheet(Частые вопросы,Библиотека ссылок,Правила прграммы)
void showSimpleSheet(
  BuildContext context,
  SimpleSheetModel model, [
  List<TopicModel>? topics,
]) {
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
          topics: topics,
        ),
      );
    },
  );
}

//* Функция вывода bottomSheet без элементов каталога
void showSheetWithoutItems(
  BuildContext context,
  BaseCatalogSheetModel model,
  CatalogItemModel item,
) {
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
          model: model,
          controller: controller,
          item: item,
        ),
      );
    },
  );
}

void showLoader(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (context) {
      return Center(
        child: Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            color: AppTheme.mystic,
            borderRadius: BorderRadius.circular(5),
          ),
          child: const Center(
            child: AnimatedLoader(),
          ),
        ),
      );
    },
  );
}

void showFlushbar(String title) {
  Flushbar<void>(
    messageText: Text(
      title,
      textAlign: TextAlign.center,
      style: AppStyles.p1White,
    ),
    duration: const Duration(
      seconds: 3,
    ),
    flushbarPosition: FlushbarPosition.TOP,
    borderRadius: const BorderRadius.only(
      bottomLeft: Radius.circular(5),
      bottomRight: Radius.circular(5),
    ),
  ).show(Keys.mainNav.currentContext!);
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
