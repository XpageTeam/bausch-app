import 'package:bausch/models/sheets/base_catalog_sheet_model.dart';
import 'package:bausch/navigation/bottom_sheet_navigation.dart';
import 'package:bausch/packages/bottom_sheet/bottom_sheet.dart';
import 'package:bausch/sections/sheets/sheet.dart';
import 'package:bausch/widgets/loader/animated_loader.dart';
import 'package:flutter/material.dart';

Future<void> showSheet<T>(
  BuildContext context,
  BaseCatalogSheetModel model, [
  T? args,
  // Этот параметр нужен для того, чтоб
  // из секции "вам может быть интересно" можно было перейти
  // сразу в товар
  String? initialRoute,
]) {
  return showFlexibleBottomSheet<void>(
    useRootNavigator: false,
    minHeight: 0,
    initHeight: 0.95,
    maxHeight: 0.95,
    anchors: [0, 0.6, 0.95],
    context: context,
    isCollapsible: true,
    builder: (context, controller, d) {
      return SheetWidget(
        child: BottomSheetNavigation<T>(
          controller: controller,
          sheetModel: model,
          args: args,
          initialRoute: initialRoute,
        ),
      );
    },
  );
}

void showLoader(BuildContext context) {
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.8),
    builder: (context) {
      return const Center(
        child: AnimatedLoader(),
      );
    },
  );
}

/*
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
    flushbarStyle: FlushbarStyle.GROUNDED,
    borderRadius: const BorderRadius.only(
      bottomLeft: Radius.circular(5),
      bottomRight: Radius.circular(5),
    ),
    backgroundColor: Colors.red,
  ).show(Keys.mainNav.currentContext!);
}*/

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

String setTheImg(String type) {
  switch (type) {
    case 'offline':
      return 'assets/discount-in-optics.png';
    case 'promo_code_immediately':
      return 'assets/offers-from-partners.png';
    case 'free_product':
      return 'assets/free-packaging.png';
    case 'onlineShop':
      return 'assets/discount-in-online-store.png';
    case 'promo_code_video':
      return 'assets/webinar-recordings.png';
    default:
      return 'assets/online-consultations.png';
  }
}
