import 'package:bausch/models/sheets/base_catalog_sheet_model.dart';
import 'package:bausch/navigation/bottom_sheet_navigation.dart';
import 'package:bausch/sections/my_lenses/my_lenses_wm.dart';
import 'package:bausch/sections/sheets/other_draggable_scrollable_sheet.dart';
import 'package:bausch/sections/sheets/sheet.dart';
import 'package:bausch/sections/sheets/widgets/bottom_sheet_page.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/widgets/loader/animated_loader.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';

Future<void> showSheet<T>(
  BuildContext context,
  BaseCatalogSheetModel model, [
  T? args,

  // Этот параметр нужен для того, чтоб
  // из секции "вам может быть интересно" можно было перейти
  // сразу в товар
  String? initialRoute,
  MyLensesWM? myLensesWM,
]) {
  var isAlreadyPop = false;
  return showFlexibleBottomSheet<void>(
    minHeight: 0,
    initHeight: 0.95,
    maxHeight: 0.95,
    anchors: [0, 0.6, 0.95],
    context: context,
    // isDismissible: false,
    bottomSheetColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.8),
    duration: const Duration(milliseconds: 300),
    builder: (context, controller, d) {
      return NotificationListener<DraggableScrollableNotification>(
        onNotification: (notification) {
          final offset = notification.extent;

          if (offset < 0.2 && !isAlreadyPop) {
            isAlreadyPop = true;
            Navigator.of(context).pop();
          }

          return true;
        },
        child: WillPopScope(
          onWillPop: () {
            if (isAlreadyPop) return Future(() => false);

            final contentContext = Keys.bottomNav.currentContext;
            if (contentContext == null) return Future(() => true);

            final canPopContent = Navigator.of(contentContext).canPop();
            if (canPopContent) {
              Navigator.of(contentContext).pop();
              return Future(() => false);
            }
            isAlreadyPop = true;

            return Future(() => true);
          },
          child: SheetWidget(
            onPop: () {
              isAlreadyPop = true;
              Navigator.of(context).pop();
            },
            child: BottomSheetNavigation<T>(
              controller: controller,
              sheetModel: model,
              args: args,
              initialRoute: initialRoute,
              myLensesWM: myLensesWM,
            ),
          ),
        ),
      );
    },
  );

  // final draggableScrollableController = OtherDraggableScrollableController();

  // return Navigator.of(context).push(
  //   PageRouteBuilder(
  //     opaque: false,
  //     reverseTransitionDuration: Duration(milliseconds: 100),
  //     pageBuilder: (context, animation, secondaryAnimation) {
  //       return BottomSheetPage(
  //         onPop: () {
  //           isAlreadyPop = true;
  //           Navigator.of(context).pop();
  //         },
  //         draggableScrollableController: draggableScrollableController,
  //         builder: (_, controller) =>
  //             NotificationListener<DraggableScrollableNotification>(
  //           onNotification: (notification) {
  //             final offset = notification.extent;

  //             if (offset < 0.05 && !isAlreadyPop) {
  //               isAlreadyPop = true;
  //               Navigator.of(context).pop();
  //             }

  //             return true;
  //           },
  //           child: WillPopScope(
  //             onWillPop: () {
  //               if (isAlreadyPop) return Future(() => false);

  //               final contentContext = Keys.bottomNav.currentContext;
  //               if (contentContext == null) return Future(() => true);

  //               final canPopContent = Navigator.of(contentContext).canPop();
  //               if (canPopContent) {
  //                 Navigator.of(contentContext).pop();
  //                 return Future(() => false);
  //               }
  //               isAlreadyPop = true;

  //               return Future(() => true);
  //             },
  //             child: SheetWidget(
  //               onPop: () {
  //                 isAlreadyPop = true;
  //                 Navigator.of(context).pop();
  //               },
  //               child: BottomSheetNavigation<T>(
  //                 controller: controller,
  //                 sheetModel: model,
  //                 args: args,
  //                 initialRoute: initialRoute,
  //                 myLensesWM: myLensesWM,
  //               ),
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   ),
  // );
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
