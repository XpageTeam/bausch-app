import 'dart:async';

import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/exceptions/success_false.dart';
import 'package:bausch/models/catalog_item/promo_item_model.dart';
import 'package:bausch/sections/sheets/screens/discount_optics/discount_type.dart';
import 'package:bausch/sections/sheets/screens/discount_optics/widget_models/discount_optics_screen_wm.dart';
import 'package:bausch/sections/sheets/widgets/code_downloader/code_downloader.dart';
import 'package:bausch/static/static_data.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class FinalDiscountWM extends WidgetModel {
  final BuildContext context;
  final PromoItemModel itemModel;
  final int? orderId;
  final Optic? discountOptic;
  final DiscountType discountType;

  final promocodeState = EntityStreamedState<String>();
  final enabledState = StreamedState<bool>(false);

  final VoidAction buttonAction = VoidAction();

  FinalDiscountWM({
    required this.context,
    required this.discountType,
    required this.itemModel,
    this.orderId,
    this.discountOptic,
  }) : super(
          const WidgetModelDependencies(),
        );

  @override
  void onLoad() {
    _getPromocode();
    super.onLoad();
  }

  @override
  void onBind() {
    buttonAction.bind((_) {
      Keys.mainContentNav.currentState!.pop();
    });

    super.onBind();
  }

  Future<void> _getPromocode() async {
    await promocodeState.loading('Генерируем ваш промокод...');

    CustomException? error;

    try {
      if (orderId != null) {
        await promocodeState.content(
          await CodeDownloader.downloadCode(orderId!),
        );
      }
      unawaited(enabledState.accept(true));
    } on DioError catch (e) {
      error = CustomException(
        title: 'При отправке запроса произошла ошибка',
        subtitle: e.message,
        ex: e,
      );
    } on ResponseParseException catch (e) {
      error = CustomException(
        title: 'При чтении ответа от сервера произошла ошибка',
        subtitle: e.toString(),
        ex: e,
      );
    } on SuccessFalse catch (e) {
      error = CustomException(
        title: e.toString(),
        ex: e,
      );
    }

    if (error != null) {
      //showTopError(error);
      await promocodeState.error(error);
    }
  }
}
