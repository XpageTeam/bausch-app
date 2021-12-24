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
import 'package:yandex_mapkit/yandex_mapkit.dart';

class DiscountOpticsScreenWM extends WidgetModel {
  final BuildContext context;
  final PromoItemModel itemModel;

  final DiscountType discountType;

  final discountOpticsStreamed = EntityStreamedState<List<Optic>>();
  final currentDiscountOptic = StreamedState<Optic?>(null);
  final setCurrentOptic = StreamedAction<Optic>();

  final buttonAction = VoidAction();

  late final List<OpticCity> cities;

  late final List<String> legalInfoTexts;
  late final String selectHeaderText;
  late final String warningText;
  late final String howToUseText;

  late int difference;

  bool get isEnough => difference <= 0;

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

    super.onLoad();
  }

  @override
  void onBind() {
    setCurrentOptic.bind(
      currentDiscountOptic.accept,
    );

    buttonAction.bind(
      (_) {
        if (!isEnough) {
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

      cities = repository.cities;

      unawaited(
        discountOpticsStreamed.content(
          repository.cities.first.optics,
          // repository.cities.map((e) => e.optics).toList(),
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
        // ignore: prefer_adjacent_string_concatenation
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
        // ignore: prefer_adjacent_string_concatenation
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
  static Future<OpticRepository> load(
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

    final dor = DiscountOpticsRepository.fromList(res.data as List<dynamic>);
    final opticRepository = OpticRepository.fromDiscountOpticsRepository(dor);

    return opticRepository;
  }
}

class OpticRepository {
  final List<OpticCity> cities;

  OpticRepository(this.cities);

  factory OpticRepository.fromDiscountOpticsRepository(
    DiscountOpticsRepository repository,
  ) {
    final cityNames = <String>{};

    for (final discounOptic in repository.discountOptics) {
      for (final discountOpticShop in discounOptic.disountOpticShops!) {
        final mayBeDirtyCityName = discountOpticShop.address.split(',').first;

        if (mayBeDirtyCityName.split(' ').length > 1) {
          cityNames.add(
            mayBeDirtyCityName.split(' ')[1],
          );
        } else {
          cityNames.add(
            mayBeDirtyCityName,
          );
        }
      }
    }

    final cities = <OpticCity>[];

    for (final cityName in cityNames) {
      final optics = <Optic>[];

      for (final discounOptic in repository.discountOptics) {
        final opticShops = <OpticShop>[];
        var hasThisDiscount = false;

        for (final disountOpticShop in discounOptic.disountOpticShops!) {
          if (disountOpticShop.address.startsWith(cityName)) {
            hasThisDiscount = true;
            opticShops.add(
              OpticShop(
                address: disountOpticShop.address,
                coords: disountOpticShop.coord,
                phones: disountOpticShop.phone,
                title: discounOptic.title,
              ),
            );
          }
        }
        if (hasThisDiscount) {
          optics.add(
            Optic(
              id: discounOptic.id,
              title: discounOptic.title,
              shopCode: discounOptic.shopCode,
              logo: discounOptic.logo,
              link: discounOptic.link,
              shops: opticShops,
            ),
          );
          hasThisDiscount = false;
        }
      }
      cities.add(
        OpticCity(
          title: cityName,
          optics: optics,
        ),
      );
    }

    return OpticRepository(cities);
  }

  // TODO(Nikolay): Сделать фабрику для списка всех адресов.
}

class OpticCity {
  // final int id;
  final String title;

  final List<Optic> optics;

  OpticCity({
    required this.title,
    required this.optics,
  });
}

class Optic {
  final int id;
  final String title;
  final String? shopCode;
  final String? logo;
  final String? link;
  final List<OpticShop> shops;

  Optic({
    required this.id,
    required this.title,
    required this.shopCode,
    required this.logo,
    required this.link,
    required this.shops,
  });
}

class OpticShop {
  // final int id;
  final String title;
  final List<String> phones;
  final String address;

  final Point coords;

  OpticShop({
    required this.title,
    required this.phones,
    required this.address,
    required this.coords,
  });
}
