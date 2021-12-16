import 'dart:async';

import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/exceptions/success_false.dart';
import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/models/catalog_item/promo_item_model.dart';
import 'package:bausch/models/discount_optic/discount_optic.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:bausch/repositories/user/user_writer.dart';
import 'package:bausch/sections/sheets/sheet_screen.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/widgets/123/default_notification.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class DiscountOpticsVerificationWM extends WidgetModel {
  final BuildContext context;
  final PromoItemModel itemModel;
  final DiscountOptic discountOptic;

  final loadingState = StreamedState<bool>(false);
  final spendPointsAction = VoidAction();

  late int points;
  late int remains;

  late UserWM userWm;

  DiscountOpticsVerificationWM({
    required this.context,
    required this.itemModel,
    required this.discountOptic,
  }) : super(
          const WidgetModelDependencies(),
        );

  @override
  void onLoad() {
    userWm = Provider.of<UserWM>(
      context,
      listen: false,
    );
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

    try {
      await OrderDiscountSaver.save(
        discountOptic,
        itemModel,
      );

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
        title: 'Произошла ошибка',
        subtitle: e.toString(),
        ex: e,
      );
    }

    unawaited(loadingState.accept(false));

    if (error != null) {
      _showTopError(error);
    } else {
      await Keys.bottomSheetItemsNav.currentState!.pushNamed(
        '/final_discount_optics',
        arguments: FinalDiscountOpticsArguments(
          model: itemModel,
          discountOptic: discountOptic,
        ),
      );
    }
  }

  void _showTopError(CustomException ex) {
    showDefaultNotification(
      title: ex.title,
      subtitle: ex.subtitle,
    );
  }
}

class FinalDiscountOpticsArguments extends SheetScreenArguments {
  final DiscountOptic discountOptic;
  FinalDiscountOpticsArguments({
    required PromoItemModel model,
    required this.discountOptic,
  }) : super(
          model: model,
        );
}

class OrderDiscountSaver {
  static Future<BaseResponseRepository> save(
    DiscountOptic optic,
    PromoItemModel model,
  ) async {
    final rh = RequestHandler();
    final resp = await rh.put<Map<String, dynamic>>(
      '/order/discount/save/',
      data: FormData.fromMap(
        <String, dynamic>{
          'productId': model.id,
          // TODO(Nikolay): Поменять цену.
          'price': 1,
          // 'addressId':optic.,
          // 'diopters':model.,
          // 'color':,
          // 'cylinder':,
          // 'axis':,
          'category': 'offline',
          'shopCode': optic.shopCode,
          'productCode': model.code,
        },
      ),
      options: rh.cacheOptions
          ?.copyWith(
            maxStale: const Duration(days: 1),
            policy: CachePolicy.request,
          )
          .toOptions(),
    );

    final data = resp.data!;

    return BaseResponseRepository.fromMap(data);
  }
}
