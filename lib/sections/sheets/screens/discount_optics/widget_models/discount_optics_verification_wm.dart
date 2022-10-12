import 'dart:async';

import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/exceptions/success_false.dart';
import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/main.dart';
import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/models/catalog_item/promo_item_model.dart';
import 'package:bausch/models/orders_data/partner_order_response.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:bausch/repositories/user/user_writer.dart';
import 'package:bausch/sections/sheets/screens/discount_optics/discount_optics_screen.dart';
import 'package:bausch/sections/sheets/screens/discount_optics/discount_type.dart';
import 'package:bausch/sections/sheets/screens/discount_optics/widget_models/discount_optics_screen_wm.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/widgets/default_notification.dart';
import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class DiscountOpticsVerificationWM extends WidgetModel {
  final BuildContext context;
  final PromoItemModel itemModel;
  final Optic discountOptic;
  final DiscountType discountType;
  final String? discount;

  final loadingState = StreamedState<bool>(false);
  final codeLoadingState = StreamedState<bool>(false);
  final spendPointsAction = VoidAction();

  final colorState = StreamedState<Color>(Colors.white);

  final promocodeState = EntityStreamedState<String?>();

  late int points;
  late int remains;

  late UserWM userWm;

  DiscountOpticsVerificationWM({
    required this.context,
    required this.itemModel,
    required this.discountOptic,
    required this.discountType,
    required this.discount,
  }) : super(
          const WidgetModelDependencies(),
        );

  @override
  void onLoad() {
    AppsflyerSingleton.sdk.logEvent(
      'discountOpticsOrder',
      <String, dynamic>{
        'id': itemModel.id,
        'title': itemModel.name,
      },
    );

    userWm = context.read<UserWM>();
    points = userWm.userData.value.data?.balance.available.toInt() ?? 0;

    remains = points - itemModel.price;

    super.onLoad();
  }

  @override
  void onBind() {
    spendPointsAction.bind(
      (_) => _spendPoints(),
    );

    super.onBind();
  }

  Future<void> _spendPoints() async {
    unawaited(loadingState.accept(true));

    CustomException? error;

    late PartnerOrderResponse result;

    try {
      result = await OrderDiscountSaver.save(
        discountOptic,
        itemModel,
        discountType.asString,
      );

      if (discountType == DiscountType.onlineShop) {
        unawaited(FirebaseAnalytics.instance.logEvent(
          name: 'web_store_discount',
          parameters: <String, dynamic>{
            'name': itemModel.name,
            'optic': discountOptic.title,
          },
        ));
      }

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
      unawaited(AppsflyerSingleton.sdk.logEvent(
        'discountOpticsOrderFinished',
        <String, dynamic>{
          'id': itemModel.id,
          'title': itemModel.name,
        },
      ));

      await Keys.bottomNav.currentState!.pushNamedAndRemoveUntil(
        '/final_discount_optics',
        (route) => route.isCurrent,
        arguments: DiscountOpticsArguments(
          model: itemModel,
          discountOptic: discountOptic,
          discountType: discountType,
          orderDataResponse: result,
          discount: discount,
        ),
      );
    }
  }
}

class OrderDiscountSaver {
  static Future<PartnerOrderResponse> save(
    Optic optic,
    PromoItemModel model,
    String category,
  ) async {
    final rh = RequestHandler();
    final resp = await rh.put<Map<String, dynamic>>(
      '/order/discount/save/',
      data: FormData.fromMap(
        <String, dynamic>{
          'productId': model.id,
          'price': model.price,
          // TODO(all): неясно, откуда брать параметры

          // 'addressId':optic.,
          // 'diopters':model.,
          // 'color':,
          // 'cylinder':,
          // 'axis':,
          'shopName': optic.title,
          'category': category,
          'shopCode': optic.shopCode,
          'productCode': model.code,
        },
      ),
    );

    final data = BaseResponseRepository.fromMap(resp.data!);

    return PartnerOrderResponse.fromMap(data.data as Map<String, dynamic>);
  }
}
