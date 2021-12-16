// ignore_for_file: unused_import

import 'dart:io';

import 'package:bausch/models/catalog_item/catalog_item_model.dart';
import 'package:bausch/models/catalog_item/partners_item_model.dart';
import 'package:bausch/models/catalog_item/product_item_model.dart';
import 'package:bausch/models/catalog_item/promo_item_model.dart';
import 'package:bausch/models/catalog_item/webinar_item_model.dart';
import 'package:bausch/models/sheets/base_catalog_sheet_model.dart';
import 'package:bausch/models/sheets/folder/sheet_with_items_model.dart';
import 'package:bausch/sections/sheets/screens/add_points/add_points_screen.dart';
import 'package:bausch/sections/sheets/screens/consultation/consultation_screen.dart';
import 'package:bausch/sections/sheets/screens/discount_online/discount_online_screen.dart';
import 'package:bausch/sections/sheets/screens/discount_online/discount_online_verification.dart';
import 'package:bausch/sections/sheets/screens/discount_online/final_discount_online.dart';
import 'package:bausch/sections/sheets/screens/discount_optics/discount_optics_screen.dart';
import 'package:bausch/sections/sheets/screens/discount_optics/discount_optics_verification.dart';
import 'package:bausch/sections/sheets/screens/discount_optics/final_discount_optics.dart';
import 'package:bausch/sections/sheets/screens/free_packaging/free_packaging_screen.dart';
import 'package:bausch/sections/sheets/screens/parners/final_partners.dart';
import 'package:bausch/sections/sheets/screens/parners/partners_screen.dart';
import 'package:bausch/sections/sheets/screens/parners/partners_verification.dart';
import 'package:bausch/sections/sheets/screens/program/program_screen.dart';
import 'package:bausch/sections/sheets/screens/webinars/final_webinar.dart';
import 'package:bausch/sections/sheets/screens/webinars/webinar_verification.dart';
import 'package:bausch/sections/sheets/screens/webinars/webinar_screen.dart';
import 'package:bausch/sections/sheets/screens/webinars/widget_models/webinar_verification_wm.dart';
import 'package:bausch/sections/sheets/sheet_screen.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/test/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//* Навигатор для bottomSheet'а с элементами каталога
class OverlayNavigationWithItems extends StatelessWidget {
  final ScrollController controller;
  final BaseCatalogSheetModel sheetModel;
  final List<CatalogItemModel> items;
  const OverlayNavigationWithItems({
    required this.sheetModel,
    required this.controller,
    required this.items,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: Keys.bottomSheetItemsNav,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        Widget page;

        switch (settings.name) {
          case '/':
            page = SheetScreen(
              sheetModel: sheetModel,
              controller: controller,
              items: items,
              //path: path(sheetModel.type),
            );

            break;

          case '/free_product':
            page = FreePackagingScreen(
              controller: controller,
              model: (settings.arguments as SheetScreenArguments).model,
            );
            break;

          case '/add_points':
            page = AddPointsScreen(
              controller: controller,
            );
            break;

          case '/offline':
            page = DiscountOpticsScreen(
              controller: controller,
              model: (settings.arguments as SheetScreenArguments).model
                  as PromoItemModel,
            );
            break;

          case '/onlineShop':
            page = DiscountOnlineScreen(
              controller: controller,
              model: (settings.arguments as SheetScreenArguments).model
                  as PromoItemModel,
            );
            break;

          case '/promo_code_immediately':
            page = PartnersScreen(
              controller: controller,
              model: (settings.arguments as SheetScreenArguments).model
                  as PartnersItemModel,
            );
            break;

          case '/promo_code_video':
            page = WebinarScreen(
              controller: controller,
              model: (settings.arguments as SheetScreenArguments).model
                  as WebinarItemModel,
            );
            break;

          case '/verification_discount_optics':
            page = DiscountOpticsVerification(
              controller: controller,
              model: (settings.arguments as SheetScreenArguments).model
                  as PromoItemModel,
            );
            break;

          case '/verification_discount_online':
            page = DiscountOnlineVerification(
              controller: controller,
              model: (settings.arguments as SheetScreenArguments).model
                  as PromoItemModel,
            );
            break;

          case '/verification_webinar':
            page = WebinarVerification(
              controller: controller,
              model: (settings.arguments as SheetScreenArguments).model,
            );
            break;

          case '/verification_partners':
            page = PartnersVerification(
              controller: controller,
              model: (settings.arguments as SheetScreenArguments).model
                  as PartnersItemModel,
            );
            break;

          case '/final_webinar':
            page = FinalWebinar(
              controller: controller,
              model: (settings.arguments as FinalWebinarArguments).model,
              videoId: (settings.arguments as FinalWebinarArguments).videoId,
            );
            break;

          case '/final_partners':
            page = FinalPartners(
              controller: controller,
              model: (settings.arguments as SheetScreenArguments).model
                  as PartnersItemModel,
            );
            break;

          case '/final_discount_optics':
            page = FinalDiscountOptics(
              controller: controller,
              model: (settings.arguments as SheetScreenArguments).model
                  as PromoItemModel,
            );
            break;
          case '/final_discount_online':
            page = FinalDiscountOptics(
              controller: controller,
              model: (settings.arguments as SheetScreenArguments).model
                  as PromoItemModel,
              text:
                  'Это ваш промокод на скидку 500 ₽ в интернет-магазине ЛинзСервис',
              buttonText: 'Скопировать и перейти на сайт',
            );
            break;

          // case '/final_free_packaging':
          //   page = FinalWebinar(
          //     controller: controller,
          //     model: Models.items[2],
          //   );
          //   break;

          // case '/program':
          //   page = ProgramScreen(controller: controller);
          //   break;

          // case '/addpoints':
          //   page = FinalWebinar(
          //     controller: controller,
          //     model: Models.items[2],
          //   );
          //   break;

          default:
            page = SheetScreen(
              sheetModel: sheetModel,
              controller: controller,
              items: items,
              //path: path(sheetModel.type),
            );
        }

        if (Platform.isIOS){
          return CupertinoPageRoute<void>(builder: (context) {
            return page;
          });
        } else {
          return MaterialPageRoute<void>(builder: (context) {
            return page;
          });
        }

        // return PageRouteBuilder<dynamic>(
        //   pageBuilder: (_, __, ___) => page,
        //   transitionsBuilder: (context, animation, anotherAnimation, child) {
        //     animation =
        //         CurvedAnimation(parent: animation, curve: Curves.easeInOutExpo);
        //     return SlideTransition(
        //       position: Tween(
        //         begin: const Offset(1.0, 0.0),
        //         end: Offset.zero,
        //       ).animate(animation),
        //       child: page,
        //     );
        //   },
        // );
      },
    );
  }

  String path(SheetWithItemsType type) {
    switch (type) {
      case SheetWithItemsType.discountOptics:
        return '/discount_optics';

      case SheetWithItemsType.webinar:
        return '/webinar';

      case SheetWithItemsType.packaging:
        return '/free_packaging';

      case SheetWithItemsType.discountOnline:
        return '/discount_online';

      case SheetWithItemsType.partners:
        return '/partners';
    }
  }
}
