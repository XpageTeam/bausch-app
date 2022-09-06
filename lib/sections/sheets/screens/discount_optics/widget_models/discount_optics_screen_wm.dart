import 'dart:async';

import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/exceptions/success_false.dart';
import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/models/catalog_item/promo_item_model.dart';
import 'package:bausch/models/discount_optic/discount_optic.dart';
import 'package:bausch/models/shop/shop_model.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:bausch/repositories/discount_optics/discount_optics_repository.dart';
import 'package:bausch/repositories/shops/shops_repository.dart';
import 'package:bausch/sections/profile/profile_settings/screens/city/city_screen.dart';
import 'package:bausch/sections/sheets/screens/discount_optics/discount_optics_screen.dart';
import 'package:bausch/sections/sheets/screens/discount_optics/discount_type.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/widgets/123/default_notification.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
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
  final selectCity = VoidAction();
  final currentCity = StreamedState<String?>(null);

  final colorState = StreamedState<Color>(AppTheme.mystic);

  final buttonAction = VoidAction();

  late final List<OpticCity> cities;

  late final List<String> legalInfoTexts;
  late final String selectHeaderText;
  late final String warningText;
  late final String howToUseText;

  List<Optic> allOptics = [];
  Set<String> citiesForOnlineShop = {};

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
              orderDataResponse: null,
            ),
          );
        }
      },
    );
    selectCity.bind((_) => _selectCity());

    super.onBind();
  }

  Future<void> _selectCity() async {
    final cityName = await Keys.mainNav.currentState!.push<String>(
      PageRouteBuilder<String>(
        pageBuilder: (context, animation, secondaryAnimation) => CityScreen(
          citiesWithShops: citiesForOnlineShop.toList(),
          withFavoriteItems: true,
        ),
      ),
    );

    if (cityName != null && cityName != currentCity.value) {
      await currentDiscountOptic.accept(null);
      unawaited(currentCity.accept(cityName));
      unawaited(
        discountOpticsStreamed.content(
          allOptics
              .where(
                (optic) =>
                    optic.cities != null &&
                    optic.cities!.any((element) => element == cityName),
              )
              .toList(),
        ),
      );
    }
  }

  Future<void> _loadDiscountOptics() async {
    unawaited(discountOpticsStreamed.loading());

    CustomException? ex;

    try {
      final repository = OpticCititesRepository.fromDiscountOpticsRepository(
        await DiscountOpticsLoader.load(
          discountType.asString,
          itemModel.code,
        ),
        discountType.asString,
      );

      cities = repository.cities;
      final discountOptics = <Optic>[];

      for (final city in repository.cities) {
        for (final optic in city.optics) {
          if (!discountOptics.any((e) => e.id == optic.id)) {
            discountOptics.add(optic);
          }
        }
      }

      if (discountType == DiscountType.onlineShop) {
        citiesForOnlineShop =
            discountOptics.where((optic) => optic.cities != null).fold(
          {},
          (arr, optic) => arr..addAll(optic.cities!),
        );
      }

      allOptics = discountOptics;
      unawaited(
        discountOpticsStreamed.content(discountOptics),
      );
    } on DioError catch (e) {
      ex = CustomException(
        title: 'При отправке запроса произошла ошибка',
        subtitle: e.message,
      );
      unawaited(discountOpticsStreamed.error(ex));
    } on ResponseParseException catch (e) {
      ex = CustomException(
        title: 'При чтении ответа от сервера произошла ошибка',
        subtitle: e.toString(),
      );
      unawaited(discountOpticsStreamed.error(ex));
    } on SuccessFalse catch (e) {
      ex = CustomException(
        title: e.toString(),
      );
      unawaited(discountOpticsStreamed.error(ex));
      // ignore: avoid_catches_without_on_clauses
    } //catch (e) {
    //   ex = CustomException(
    //     title: 'Произошла ошибка',
    //     subtitle: e.toString(),
    //   );
    //   unawaited(discountOpticsStreamed.error(ex));
    // }

    if (ex != null) {
      showTopError(ex);
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
      ))
          .data!,
    );

    return DiscountOpticsRepository.fromList(res.data as List<dynamic>);
  }
}

class OpticCititesRepository {
  final List<OpticCity> cities;

  OpticCititesRepository(this.cities);

  factory OpticCititesRepository.fromDiscountOpticsRepository(
    DiscountOpticsRepository repository,
    String category,
  ) {
    if (category == 'onlineShop') {
      return OpticCititesRepository(
        [
          OpticCity(
            title: '',
            optics: repository.discountOptics
                .map(
                  (e) => Optic(
                    id: e.id,
                    title: e.title,
                    shops: [],
                    shopCode: e.shopCode,
                    logo: e.logo,
                    link: e.link,
                    cities: e.cities,
                  ),
                )
                .toList(),
          ),
        ],
      );
    }

    final cityNames = <String>{};

    for (final discounOptic in repository.discountOptics) {
      if (discounOptic.disountOpticShops != null) {
        for (final discountOpticShop in discounOptic.disountOpticShops!) {
          cityNames.add(
            discountOpticShop.city,
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

        for (final disountOpticShop
            in discounOptic.disountOpticShops ?? <DiscountOpticShop>[]) {
          if (disountOpticShop.city.toLowerCase() == cityName.toLowerCase()) {
            hasThisDiscount = true;
            opticShops.add(
              OpticShop(
                address: disountOpticShop.address,
                coords: disountOpticShop.coord,
                phones: disountOpticShop.phone,
                title: discounOptic.title,
                city: disountOpticShop.city,
                email: disountOpticShop.email,
                manager: disountOpticShop.manager,
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

    return OpticCititesRepository(cities);
  }

  factory OpticCititesRepository.fromCitiesRepository(
    CitiesRepository repository,
  ) {
    final cities = <OpticCity>[];

    for (final city in repository.cities) {
      final shopsMap = <String, List<OpticShop>>{};

      for (final shop in city.shopsRepository.shops) {
        shopsMap.update(
          shop.name,
          (shops) => shops
            ..add(
              _getOpticShopFromShopModel(shop: shop, cityName: city.name),
            ),
          ifAbsent: () =>
              [_getOpticShopFromShopModel(shop: shop, cityName: city.name)],
        );
      }
      final optics = shopsMap.entries
          .map((e) => Optic(id: city.id, title: e.key, shops: e.value))
          .toList();

      cities.add(
        OpticCity(
          id: city.id,
          title: city.name,
          optics: optics,
        ),
      );
    }

    return OpticCititesRepository(cities);
  }

  static OpticShop _getOpticShopFromShopModel({
    required ShopModel shop,
    required String cityName,
  }) {
    return OpticShop(
      title: shop.name,
      phones: shop.phones,
      address: shop.address,
      city: cityName,
      coords: shop.coords!,
      email: shop.email,
      manager: shop.manager,
      site: shop.site,
    );
  }
}

class OpticCity {
  final int? id;
  final String title;

  final List<Optic> optics;

  const OpticCity({
    required this.title,
    required this.optics,
    this.id,
  });
}

class Optic {
  final int id;
  final String title;
  final String? shopCode;
  final String? logo;
  final String? link;
  final List<OpticShop> shops;
  final List<String>? cities;

  const Optic({
    required this.id,
    required this.title,
    required this.shops,
    this.shopCode,
    this.logo,
    this.link,
    this.cities,
  });

  Optic copyWith({
    int? id,
    String? title,
    List<OpticShop>? shops,
    String? shopCode,
    String? logo,
    String? link,
  }) {
    return Optic(
      id: id ?? this.id,
      title: title ?? this.title,
      shops: shops ?? this.shops,
      shopCode: shopCode ?? this.shopCode,
      logo: logo ?? this.logo,
      link: link ?? this.link,
    );
  }
}

class OpticShop extends Equatable {
  final String title;
  final List<String> phones;
  final String address;
  final String city;
  final String? site;
  final String? email;
  final String? manager;

  final Point coords;

  @override
  List<Object?> get props => [title, phones, address, city];

  const OpticShop({
    required this.title,
    required this.phones,
    required this.address,
    required this.city,
    required this.coords,
    this.manager,
    this.email,
    this.site,
  });
}
