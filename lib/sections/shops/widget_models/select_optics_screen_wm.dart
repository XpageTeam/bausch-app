import 'dart:async';

import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/exceptions/success_false.dart';
import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/models/discount_optic/discount_optic.dart';
import 'package:bausch/models/shop/filter_model.dart';
import 'package:bausch/repositories/shops/shops_repository.dart';
import 'package:bausch/sections/profile/profile_settings/screens/city/city_screen.dart';
import 'package:bausch/sections/sheets/screens/discount_optics/widget_models/discount_optics_screen_wm.dart';
import 'package:bausch/sections/shops/map_body_wm.dart';
import 'package:bausch/static/static_data.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

enum ShopsContentType {
  map,
  list,
}

extension ShopsContentTypeAsString on ShopsContentType {
  String get asString => this == ShopsContentType.map ? 'На карте' : 'Список';
}

class SelectOpticScreenWM extends WidgetModel {
  final BuildContext context;

  final opticShopsStreamed = EntityStreamedState<List<OpticShop>>();
  final opticsStreamed = StreamedState<List<Optic>>([]);
  final currentCityStreamed = EntityStreamedState<String>();
  final contentTypeStreamed = StreamedState<ShopsContentType>(
    ShopsContentType.map,
  );
  final selectedFiltersStreamed = StreamedState<List<Filter>>([]);

  final switchAction = StreamedAction<ShopsContentType>();
  final setFirstCity = VoidAction();
  final selectCityAction = VoidAction();
  final filtersOnChanged = StreamedAction<List<Filter>>();

  List<OpticCity>? initialOptics;

  SelectOpticScreenWM({
    required this.context,
    this.initialOptics,
  }) : super(
          const WidgetModelDependencies(),
        );

  @override
  void onLoad() {
    _initCurrentCity();
    if (initialOptics == null) {
      // TODO(Nikolay): Переделать.
      _loadOptics();
    } else {
      // TODO(Nikolay): Переделать.
      initialOptics = _sort(initialOptics!);
      var opticShops = <OpticShop>[];
      var optics = <Optic>[];
      if (initialOptics!
          .any((city) => city.title == currentCityStreamed.value.data)) {
        optics = initialOptics!
            .firstWhere((city) => city.title == currentCityStreamed.value.data)
            .optics;
        opticShops = optics.fold<List<OpticShop>>(
          [],
          (previousValue, element) => previousValue..addAll(element.shops),
        );
      }

      opticShopsStreamed.content(opticShops);
      opticsStreamed.accept(optics);
    }

    super.onLoad();
  }

  @override
  void onBind() {
    switchAction.bind(
      (newType) => contentTypeStreamed.accept(newType!),
    );

    selectCityAction.bind(
      (_) => _selectCity(),
    );
    setFirstCity.bind(
      (_) => _setFirstCity(),
    );

    filtersOnChanged.bind(
      (selectedFilters) => _filtersOnChanged(selectedFilters!),
    );

    super.onBind();
  }

  void _filtersOnChanged(List<Filter> selectedFilters) {
    final optics = _getOpticsByCity();

    // opticsStreamed.accept(
    //   optics
    //       .where(
    //         (optic) => selectedFilters.any(
    //           (filter) => filter.title == optic.title,
    //         ),
    //       )
    //       .toList(),
    // );
  }

  void _setFirstCity() {
    currentCityStreamed.content(initialOptics!.first.title);
    final shops = _getShopsByFilters();
    opticShopsStreamed.content(shops);
  }

  Future<void> _selectCity() async {
    final cityName = await Keys.mainNav.currentState!.push<String>(
      PageRouteBuilder<String>(
        pageBuilder: (context, animation, secondaryAnimation) => CityScreen(
          citiesWithShops: initialOptics!.map((e) => e.title).toList(),
        ),
      ),
    );

    if (cityName != currentCityStreamed.value.data) {
      unawaited(currentCityStreamed.content(cityName!));
      unawaited(opticShopsStreamed.content(
        _getShopsByFilters(),
      ));
    }
  }

  void _initCurrentCity() {
    try {
      // TODO(Nikolay): Вернуть проверку авторизации пользователя.
      // if (Provider.of<AuthWM>(context, listen: false).authStatus.value ==
      //     AuthStatus.authenticated) {
      final currentCity = Provider.of<UserWM>(
        context,
        listen: false,
      ).userData.value.data?.user.city;

      if (currentCity != null) {
        currentCityStreamed.content(currentCity);
      } else {
        currentCityStreamed.error();
      }
      // }
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      currentCityStreamed.error();
    }
  }

  List<OpticShop> _getShopsByFilters() {
    final optics = _getOpticsByCity();
    // TODO(Nikolay): Переделать.

    opticsStreamed.accept(optics);

    return optics.fold<List<OpticShop>>(
      [],
      (previousValue, element) => previousValue..addAll(element.shops),
    ).toList();
  }

  List<Optic> _getOpticsByCity() {
    var optics = <Optic>[];
    if (initialOptics!
        .any((city) => city.title == currentCityStreamed.value.data)) {
      optics = initialOptics!
          .firstWhere((city) => city.title == currentCityStreamed.value.data)
          .optics;
    } else {
      optics = initialOptics!.first.optics;
    }
    return optics;
  }

  Future<void> _loadOptics() async {
    try {
      final opticCititesRepository =
          OpticCititesRepository.fromCitiesRepository(
        await AllOpticsDownloader.load(),
      );

      initialOptics = _sort(opticCititesRepository.cities);

      unawaited(
        opticShopsStreamed.content(_getShopsByFilters()),
      );
    } on DioError catch (e) {
      unawaited(
        opticShopsStreamed.error(
          CustomException(
            title: 'Ошибка при отправке запроса на сервер',
            subtitle: e.message,
            ex: e,
          ),
        ),
      );
    } on ResponseParseException catch (e) {
      unawaited(
        opticShopsStreamed.error(
          CustomException(
            title: 'Ошибка при получении ответа с сервера',
            subtitle: e.toString(),
            ex: e,
          ),
        ),
      );
    } on SuccessFalse catch (e) {
      unawaited(
        opticShopsStreamed.error(
          CustomException(
            title: 'Произошла ошибка',
            subtitle: e.toString(),
            ex: e,
          ),
        ),
      );
    }
  }

  List<OpticCity>? _sort(List<OpticCity> cities) {
    if (cities.isEmpty) return null;
    return cities..sort((a, b) => a.title.compareTo(b.title));
  }
}
