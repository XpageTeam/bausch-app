import 'dart:async';

import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/exceptions/success_false.dart';
import 'package:bausch/help/utils.dart';
import 'package:bausch/models/catalog_item/partners_item_model.dart';
import 'package:bausch/sections/sheets/widgets/code_downloader/code_downloader.dart';
import 'package:bausch/static/static_data.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class FinalPartnersWM extends WidgetModel {
  final BuildContext context;
  final PartnersItemModel itemModel;
  final int? orderId;

  final promocodeState = EntityStreamedState<String>();
  final enabledState = StreamedState<bool>(false);

  final VoidAction buttonAction = VoidAction();
  final VoidAction copyAndLaunch = VoidAction();

  FinalPartnersWM({
    required this.context,
    required this.itemModel,
    this.orderId,
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

    copyAndLaunch.bind((_) {
      Utils.copyStringToClipboard(
        itemModel.staticPromoCode!,
      );
      Utils.tryLaunchUrl(
        rawUrl: itemModel.link!,
        isPhone: false,
      );
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
        unawaited(enabledState.accept(true));
      } else {
        error = const CustomException(title: 'Не передан orderId');
      }
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
