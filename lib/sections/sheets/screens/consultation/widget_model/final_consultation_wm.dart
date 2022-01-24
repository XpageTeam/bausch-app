import 'dart:async';

import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/exceptions/success_false.dart';
import 'package:bausch/models/catalog_item/consultattion_item_model.dart';
import 'package:bausch/sections/sheets/widgets/code_downloader/code_downloader.dart';
import 'package:bausch/widgets/123/default_notification.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class FinalConsultationWM extends WidgetModel {
  final BuildContext context;
  final ConsultationItemModel itemModel;
  final int orderId;

  final promocodeState = EntityStreamedState<String>();

  FinalConsultationWM({
    required this.context,
    required this.itemModel,
    required this.orderId,
  }) : super(
          const WidgetModelDependencies(),
        );

  @override
  void onLoad() {
    _getPromocode();

    super.onLoad();
  }

  Future<void> _getPromocode() async {
    await promocodeState.loading('Генерируем ваш промокод...');

    CustomException? error;

    try {
      await promocodeState.content(
        await CodeDownloader.downloadCode(orderId),
      );
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
