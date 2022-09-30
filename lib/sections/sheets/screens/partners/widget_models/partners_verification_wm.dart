// ignore_for_file: avoid_catches_without_on_clauses

import 'dart:async';

import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/exceptions/success_false.dart';
import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/models/catalog_item/catalog_item_model.dart';
import 'package:bausch/models/catalog_item/partners_item_model.dart';
import 'package:bausch/models/orders_data/partner_order_response.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:bausch/repositories/user/user_writer.dart';
import 'package:bausch/sections/sheets/sheet_screen.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/widgets/default_notification.dart';
import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class PartnersVerificationWM extends WidgetModel {
  final BuildContext context;
  final PartnersItemModel itemModel;

  final loadingState = StreamedState<bool>(false);

  final spendPointsAction = VoidAction();

  final colorState = StreamedState<Color>(Colors.white);

  int remains = 0;

  late UserWM userWm;

  PartnersVerificationWM({
    required this.context,
    required this.itemModel,
  }) : super(
          const WidgetModelDependencies(),
        );
  @override
  void onLoad() {
    userWm = Provider.of<UserWM>(
      context,
      listen: false,
    );
    final points = userWm.userData.value.data?.balance.available.toInt() ?? 0;
    remains = points - itemModel.price;
    super.onLoad();
  }

  @override
  void onBind() {
    spendPointsAction.bind((_) => _spendPoints());
    super.onBind();
  }

  Future<void> _spendPoints() async {
    unawaited(loadingState.accept(true));

    CustomException? error;

    PartnerOrderResponse? response;

    try {
      response = await OrderPartnerItemSaver.save(
        itemModel,
        'partner',
      );

      unawaited(FirebaseAnalytics.instance.logEvent(
        name: 'partner_order',
        parameters: <String, dynamic>{
          'partner_name_parameter': itemModel.name,
        },
      ));

      final userRepository = await UserWriter.checkUserToken();
      if (userRepository == null) return;

      await userWm.userData.content(userRepository);
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

    unawaited(loadingState.accept(false));

    if (error != null) {
      showTopError(error);
    } else {
      await Keys.bottomNav.currentState!.pushNamedAndRemoveUntil(
        '/final_partners',
        (route) => route.isCurrent,
        arguments: ItemSheetScreenArguments(
          model: itemModel,
          orderData: response,
        ),
      );
    }
  }
}

class OrderPartnerItemSaver {
  static Future<PartnerOrderResponse> save(
    CatalogItemModel model,
    String category,
  ) async {
    final rh = RequestHandler();

    final response =
        BaseResponseRepository.fromMap((await rh.put<Map<String, dynamic>>(
      '/order/partner/',
      data: FormData.fromMap(
        <String, dynamic>{
          'productId': model.id,
          'price': model.price,
          'category': category,
        },
      ),
    ))
            .data!);

    return PartnerOrderResponse.fromMap(response.data as Map<String, dynamic>);
  }
}
