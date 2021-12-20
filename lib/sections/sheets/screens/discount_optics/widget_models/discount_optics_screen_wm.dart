import 'dart:async';

import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/exceptions/success_false.dart';
import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/models/catalog_item/promo_item_model.dart';
import 'package:bausch/models/discount_optic/discount_optic.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:bausch/repositories/discount_optics/discount_optics_repository.dart';
import 'package:bausch/sections/sheets/screens/discount_optics/discount_optics_screen.dart';
import 'package:bausch/sections/sheets/screens/discount_optics/discount_type.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class DiscountOpticsScreenWM extends WidgetModel {
  final BuildContext context;
  final PromoItemModel itemModel;

  final DiscountType discountType;

  final discountOpticsStreamed = EntityStreamedState<List<DiscountOptic>>();
  final currentDiscountOptic = StreamedState<DiscountOptic?>(null);
  final setCurrentOptic = StreamedAction<DiscountOptic>();

  final buttonAction = VoidAction();

  late int difference;

  late List<String> legalInfoTexts;
  late String selectHeaderText;
  late String warningText;
  late String howToUseText;

  DiscountOpticsScreenWM({
    required this.context,
    required this.itemModel,
    required this.discountType,
  }) : super(
          const WidgetModelDependencies(),
        ) {
    _initTexts();
    _loadDiscountOptics();
  }

  @override
  void onLoad() {
    final points = Provider.of<UserWM>(
          context,
          listen: false,
        ).userData.value.data?.balance.available.toInt() ??
        0;
    difference = itemModel.price - points;
  }

  @override
  void onBind() {
    setCurrentOptic.bind(
      currentDiscountOptic.accept,
    );

    buttonAction.bind(
      (_) {
        if (difference > 0) {
          Navigator.of(context).pushNamed(
            '/add_points',
          );
        } else {
          Navigator.of(context).pushNamed(
            '/verification_discount_optics',
            arguments: DiscountOpticsArguments(
              model: itemModel,
              discountOptic: currentDiscountOptic.value!,
              discountType: discountType,
            ),
          );
        }
      },
    );
    super.onBind();
  }

  Future<void> _loadDiscountOptics() async {
    unawaited(discountOpticsStreamed.loading());

    try {
      final repository = await DiscountOpticsLoader.load(
        discountType.asString,
        itemModel.code,
      );
      unawaited(
        discountOpticsStreamed.content(
          repository.discountOptics,
        ),
      );
    } on DioError catch (e) {
      unawaited(
        discountOpticsStreamed.error(
          CustomException(
            title: 'При отправке запроса произошла ошибка',
            subtitle: e.message,
          ),
        ),
      );
    } on ResponseParseException catch (e) {
      unawaited(
        discountOpticsStreamed.error(
          CustomException(
            title: 'При чтении ответа от сервера произошла ошибка',
            subtitle: e.toString(),
          ),
        ),
      );
    } on SuccessFalse catch (e) {
      unawaited(
        discountOpticsStreamed.error(
          CustomException(
            title: 'Произошла ошибка',
            subtitle: e.toString(),
          ),
        ),
      );
    }
  }

  void _initTexts() {
    if (discountType == DiscountType.offline) {
      legalInfoTexts = [
        'Перед заказом промокода на скидку необходимо проверить наличие продукта ' +
            '(на сайте и / или по контактному номеру телефона оптики).',
        'Срок действия промокода и количество промокодов ограничены.',
      ];
      selectHeaderText = 'Выбрать сеть оптик';
      warningText =
          'Перед тем, как оформить заказ, свяжитесь с оптикой и узнайте о наличии продукта.';
      howToUseText =
          'Покажите промокод в оптике при покупке выбранного продукта. '
          'Срок действия промокода и количество промокодов ограничены. ';
    } else {
      legalInfoTexts = [
        'Перед заказом промокода на скидку необходимо проверить наличие продукта, а также условия доставки ' +
            '(на сайте и / или по контактному номеру телефона интернет-магазина).',
        'Срок действия промокода и количество промокодов ограничены.',
      ];
      selectHeaderText = 'Выбрать интернет-магазин';
      warningText =
          'Перед тем как оформить заказ, узнайте о наличии продукта в интернет-магазине';
      howToUseText =
          'Положите в корзину выбранный при заказе поощрения продукт. '
          'При оформлении заказа введите промокод в поле «Промокод» и нажмите «Применить». '
          'Итоговая стоимость со скидкой отобразится в корзине.';
    }
  }
}

class DiscountOpticsLoader {
  static Future<DiscountOpticsRepository> load(
    String category,
    String productCode,
  ) async {
    final rh = RequestHandler();

    final res = BaseResponseRepository.fromMap(
      (await rh.get<Map<String, dynamic>>(
        '/order/available-optics/',
        queryParameters: <String, dynamic>{
          'category': category,
          'productCode': productCode,
        },
        options: rh.cacheOptions
            ?.copyWith(
              maxStale: const Duration(days: 2),
              policy: CachePolicy.request,
            )
            .toOptions(),
      ))
          .data!,
    );

    return DiscountOpticsRepository.fromList(res.data as List<dynamic>);
  }
}
