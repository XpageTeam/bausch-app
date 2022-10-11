// ignore_for_file: avoid_annotating_with_dynamic

import 'dart:async';

import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/exceptions/success_false.dart';
import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/main.dart';
import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/models/catalog_item/promo_item_model.dart';
import 'package:bausch/models/discount_optic/discount_optic.dart';
import 'package:bausch/models/shop/shop_model.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:bausch/repositories/discount_optics/discount_optics_repository.dart';
import 'package:bausch/repositories/shops/shops_repository.dart';
import 'package:bausch/sections/order_registration/widgets/blue_button.dart';
import 'package:bausch/sections/order_registration/widgets/order_button.dart';
import 'package:bausch/sections/profile/profile_settings/screens/city/city_screen.dart';
import 'package:bausch/sections/sheets/screens/discount_optics/discount_optics_screen.dart';
import 'package:bausch/sections/sheets/screens/discount_optics/discount_type.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/anti_glow_behavior.dart';
import 'package:bausch/widgets/default_notification.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
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
  final selectOnlineCity = VoidAction();
  final currentOnlineCity = StreamedState<String?>(null);
  final currentOfflineCity = StreamedState<String?>(null);

  final colorState = StreamedState<Color>(AppTheme.mystic);

  final buttonAction = VoidAction();

  late final List<OpticCity> cities;

  late final List<String> legalInfoTexts;
  late final String selectHeaderText;
  late final String warningText;
  late final String howToUseText;
  late final UserWM userWM;

  /// Для того, чтобы можно было единожды показать юзеру диалог (пока этот класс не пересоздался, естественно)
  bool wasDialogShowed = false;

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
        );

  @override
  void onLoad() {
    userWM = context.read<UserWM>();

    final userData = userWM.userData.value.data;

    final points = userData?.balance.available.toInt() ?? 0;
    difference = itemModel.price - points;

    currentOfflineCity.accept(userData?.user.city);
    currentOnlineCity.accept(userData?.user.city);

    _initTexts();
    _loadDiscountOptics();
    super.onLoad();
  }

  @override
  void onBind() {
    discountOpticsStreamed.bind((_) {
      if (!discountOpticsStreamed.value.hasError &&
          !discountOpticsStreamed.value.isLoading &&
          discountType == DiscountType.offline &&
          discountOpticsStreamed.value.data!.isEmpty) {
        AppsflyerSingleton.sdk.logEvent('discountOpticsEmpty', null);
      }
    });

    setCurrentOptic.bind(
      (optic) async {
        if (optic != null) {
          unawaited(currentDiscountOptic.accept(optic));

          if (discountType == DiscountType.onlineShop) {
            unawaited(
              AppsflyerSingleton.sdk.logEvent(
                'discountOpticsSetOptic',
                <String, dynamic>{
                  'opticID': optic.id,
                  'opticName': optic.title,
                  'cityName': currentOnlineCity.value,
                },
              ),
            );

            return;
          }

          final cityName = optic.shops.first.city;
          final oldCityName = currentOfflineCity.value;

          await currentOfflineCity.accept(cityName);

          unawaited(
            AppsflyerSingleton.sdk.logEvent(
              'discountOpticsSetOptic',
              <String, dynamic>{
                'opticID': optic.id,
                'opticName': optic.title,
                'cityName': cityName,
              },
            ),
          );

          unawaited(
            discountOpticsStreamed.content(
              await _filterOpticsBySelectedOfflineCity(),
            ),
          );

          if (!wasDialogShowed && oldCityName != cityName) {
            wasDialogShowed = true;
            _showRememberCityDialog(
              confirmCallback: (ctx) {
                userWM.updateUserData(
                  userWM.userData.value.data!.user.copyWith(city: cityName),
                  successMessage: 'Город успешно изменён',
                );
                Navigator.of(ctx).pop();
              },
            );
          }
        }
      },
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
    selectOnlineCity.bind((_) => _selectOnlineCity());

    super.onBind();
  }

  Future<void> setOfflineCity(String? cityName) async {
    if (cityName != null && currentOfflineCity.value != cityName) {
      unawaited(discountOpticsStreamed.loading());

      await currentOfflineCity.accept(cityName);

      unawaited(currentDiscountOptic.accept(null));

      unawaited(
        discountOpticsStreamed.content(
          await _filterOpticsBySelectedOfflineCity(),
        ),
      );

      if (!wasDialogShowed) {
        wasDialogShowed = true;
        _showRememberCityDialog(
          confirmCallback: (ctx) {
            userWM.updateUserData(
              userWM.userData.value.data!.user.copyWith(city: cityName),
              successMessage: 'Город успешно изменён',
            );
            Navigator.of(ctx).pop();
          },
        );
      }
    }
  }

  Future<List<Optic>> _getOpticsByCurrentCity() async {
    var optics = <Optic>[];

    if (cities.any(_equalsCurrentCity)) {
      optics = cities.firstWhere(_equalsCurrentCity).optics;
    } else {
      final splittedCurrentCity = currentOfflineCity.value!.split(' ');

      for (final piece in splittedCurrentCity) {
        if (cities.any(
          (city) => _equalsPieceOrWithComma(city, piece),
        )) {
          optics = cities
              .firstWhere(
                (city) => _equalsPieceOrWithComma(city, piece),
              )
              .optics;
        }
      }
    }

    return optics;
  }

  bool _equalsCurrentCity(OpticCity city) {
    return city.title.toLowerCase() == currentOfflineCity.value!.toLowerCase();
  }

  bool _equalsPieceOrWithComma(OpticCity city, String piece) {
    final pieceLower = piece.toLowerCase().replaceAll(',', '');
    final cityLower = city.title.toLowerCase();

    return cityLower == pieceLower;
  }

  Future<void> _selectOnlineCity() async {
    String? moscowString;
    if (citiesForOnlineShop.any((element) => element == 'Москва')) {
      moscowString =
          citiesForOnlineShop.firstWhere((element) => element == 'Москва');
    }

    final cityName = await Keys.mainNav.currentState!.push<String>(
      PageRouteBuilder<String>(
        pageBuilder: (context, animation, secondaryAnimation) => CityScreen(
          citiesWithShops: citiesForOnlineShop.toList(),
          withFavoriteItems: [
            'Вся РФ',
            if (moscowString != null) moscowString,
          ],
        ),
      ),
    );

    if (cityName != null && cityName != currentOnlineCity.value) {
      await currentOnlineCity.accept(cityName);
      unawaited(
        discountOpticsStreamed.content(
          _filterOpticsBySelectedOnlineCity(),
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

      if (discountType.asString == 'onlineShop') {
        final hasUserCity = allOptics.any(
          (optic) =>
              optic.cities != null &&
              optic.cities!.any(
                (element) => element == currentOnlineCity.value,
              ),
        );

        if (!hasUserCity) {
          await currentOnlineCity.accept('Вся РФ');
          unawaited(
            discountOpticsStreamed.content(allOptics),
          );
        } else {
          unawaited(
            discountOpticsStreamed.content(
              _filterOpticsBySelectedOnlineCity(),
            ),
          );
        }
      } else {
        if (currentOfflineCity.value == null) {
          unawaited(
            discountOpticsStreamed.content(allOptics),
          );
        } else if (!cities.any(_equalsCurrentCity)) {
          await currentOfflineCity.accept(null);

          unawaited(
            discountOpticsStreamed.content(allOptics),
          );
        } else if (cities.any(_equalsCurrentCity)) {
          unawaited(
            discountOpticsStreamed.content(
              await _getOpticsByCurrentCity(),
            ),
          );
        }
      }
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

  List<Optic> _filterOpticsBySelectedOnlineCity() {
    return allOptics
        .where(
          (optic) =>
              optic.cities != null &&
              optic.cities!.any(
                (element) => element == currentOnlineCity.value,
              ),
        )
        .toList();
  }

  Future<List<Optic>> _filterOpticsBySelectedOfflineCity() async {
    return _getOpticsByCurrentCity();
  }

  void _showRememberCityDialog({
    required ValueChanged<BuildContext> confirmCallback,
  }) {
    showFlexibleBottomSheet<void>(
      context: Keys.mainContentNav.currentContext!,
      minHeight: 0,
      initHeight: 0.4,
      maxHeight: 0.4,
      anchors: [0, 0.4],
      bottomSheetColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.8),
      builder: (context, controller, _) {
        return Container(
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(
                5,
              ),
            ),
          ),
          child: Scaffold(
            backgroundColor: AppTheme.mystic,
            body: Stack(
              children: [
                CustomScrollView(
                  scrollBehavior: const AntiGlowBehavior(),
                  physics: const ClampingScrollPhysics(),
                  controller: controller,
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.all(8.0),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate(
                          const [
                            SizedBox(height: 40),
                            Text(
                              'Запомнить город?',
                              style: AppStyles.h1,
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              'Настроить отображение партнеров по городу можно позже в настройках',
                              style: AppStyles.p1Grey,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: SizedBox(
                        height: 20,
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  left: 0,
                  child: IgnorePointer(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Container(
                          height: 4,
                          width: 38,
                          decoration: BoxDecoration(
                            color: AppTheme.mineShaft,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: StaticData.sidePadding,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // const SizedBox(
                  //   height: 40,
                  // ),
                  BlueButton(
                    children: const [
                      Text(
                        'Да',
                        style: AppStyles.h2Bold,
                      ),
                    ],
                    onPressed: () => confirmCallback(context),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  DefaultButton(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                    ),
                    children: const [
                      Text(
                        'Нет',
                        style: AppStyles.h2Bold,
                      ),
                    ],
                    onPressed: Navigator.of(context).pop,
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        );
      },
    );
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

      // debugPrint('cityNames: ${cityNames}');
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

class OpticShopForCertificate extends OpticShop {
  final List<OpticShopFeature> features;
  final String url;
  const OpticShopForCertificate({
    required super.title,
    required super.phones,
    required super.address,
    required super.city,
    required super.coords,
    required this.features,
    required this.url,
  });

  factory OpticShopForCertificate.fromJson(Map<String, dynamic> map) {
    return OpticShopForCertificate(
      title: map['name'] as String,
      phones: (map['phones'] as List<dynamic>)
          .map((dynamic e) => e as String)
          .toList(),
      address: map['address'] as String,
      city: _parseCity(map['city'] as Map<String, dynamic>),
      coords: _parseCoords(map['coord'] as Map<String, dynamic>),
      url: map['url'] as String? ?? '',
      features: (map['features'] as List<dynamic>)
          .map(
            (dynamic e) => OpticShopFeature.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }

  static String _parseCity(Map<String, dynamic> map) {
    // return OpticCity(
    //   id: map['id'] as int,
    //   title: map['name'] as String,
    //   optics: [],
    // );
    return map['name'] as String;
  }

  static Point _parseCoords(Map<String, dynamic> map) {
    return Point(
      latitude: double.parse(map['lat'] as String),
      longitude: double.parse(map['lng'] as String),
    );
  }
}

class OpticShopFeature {
  final String xmlId;
  final String title;
  final Color? color;

  const OpticShopFeature({
    required this.xmlId,
    required this.title,
    required this.color,
  });

  factory OpticShopFeature.fromJson(Map<String, dynamic> map) {
    return OpticShopFeature(
      xmlId: map['xml_id'] as String,
      title: map['name'] as String,
      color: _getColorFromHex(
        map['color'] as String?,
      ),
    );
  }

  static Color? _getColorFromHex(String? rawHexColor) {
    if (rawHexColor == null) return null;

    var hexColor = rawHexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    if (hexColor.length == 8) {
      return Color(int.parse('0x$hexColor'));
    }
    return null;
  }
}
