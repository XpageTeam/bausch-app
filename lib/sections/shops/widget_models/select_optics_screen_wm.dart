import 'dart:async';

import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/exceptions/success_false.dart';
import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/models/shop/filter_model.dart';
import 'package:bausch/repositories/shops/shops_repository.dart';
import 'package:bausch/sections/profile/profile_settings/screens/city/city_screen.dart';
import 'package:bausch/sections/sheets/screens/discount_optics/widget_models/discount_optics_screen_wm.dart';
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

  final filteredOpticShopsStreamed = EntityStreamedState<List<OpticShop>>();
  final opticsByCityStreamed = StreamedState<List<Optic>>([]);
  final currentCityStreamed = EntityStreamedState<String>();

  final contentTypeStreamed = StreamedState<ShopsContentType>(
    ShopsContentType.map,
  );

  final switchAction = StreamedAction<ShopsContentType>();
  final setFirstCity = VoidAction();
  final selectCityAction = VoidAction();
  final filtersOnChanged = StreamedAction<List<Filter>>();

  List<OpticCity>? initialCities;

  var selectedFilters = <Filter>[];

  SelectOpticScreenWM({
    required this.context,
    this.initialCities,
  }) : super(
          const WidgetModelDependencies(),
        );

  @override
  Future<void> onLoad() async {
    _initCurrentCity();
    if (initialCities == null) {
      // TODO(Nikolay): Переделать.
      unawaited(_loadOptics());
    } else {
      // TODO(Nikolay): Переделать.
      initialCities = _sort(initialCities!);

      unawaited(opticsByCityStreamed.accept(_getOpticsByCurrentCity()));
      unawaited(filteredOpticShopsStreamed.content(_getShopsByFilters()));
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
    this.selectedFilters = selectedFilters;
    filteredOpticShopsStreamed.content(_getShopsByFilters());
  }

  void _setFirstCity() {
    currentCityStreamed.content(initialCities!.first.title);
    opticsByCityStreamed.accept(_getOpticsByCurrentCity());
    filteredOpticShopsStreamed.content(_getShopsByFilters());
  }

  Future<void> _selectCity() async {
    final cityName = await Keys.mainNav.currentState!.push<String>(
      PageRouteBuilder<String>(
        pageBuilder: (context, animation, secondaryAnimation) => CityScreen(
          citiesWithShops: initialCities!.map((e) => e.title).toList(),
        ),
      ),
    );

    if (cityName != currentCityStreamed.value.data) {
      unawaited(currentCityStreamed.content(cityName!));
      unawaited(opticsByCityStreamed.accept(_getOpticsByCurrentCity()));
      unawaited(filteredOpticShopsStreamed.content(_getShopsByFilters()));
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
    final opticsByCity = opticsByCityStreamed.value;

    if (selectedFilters.isEmpty || selectedFilters.first.id == 0) {
      return opticsByCity.fold<List<OpticShop>>(
        [],
        (previousValue, element) => previousValue..addAll(element.shops),
      ).toList();
    }

    final filteredOptics = <Optic>[];
    for (final optic in opticsByCity) {
      if (selectedFilters.any((element) => element.title == optic.title)) {
        filteredOptics.add(optic);
      }
    }

    return filteredOptics.fold<List<OpticShop>>(
      [],
      (previousValue, element) => previousValue..addAll(element.shops),
    ).toList();
  }

  List<Optic> _getOpticsByCurrentCity() {
    var optics = <Optic>[];
    if (initialCities!
        .any((city) => city.title == currentCityStreamed.value.data)) {
      optics = initialCities!
          .firstWhere((city) => city.title == currentCityStreamed.value.data)
          .optics;
    } else {
      optics = [];
    }
    return optics;
  }

  Future<void> _loadOptics() async {
    CustomException? ex;

    try {
      final opticCititesRepository =
          OpticCititesRepository.fromCitiesRepository(
        await AllOpticsDownloader.load(),
      );

      initialCities = _sort(opticCititesRepository.cities);

      await opticsByCityStreamed.accept(_getOpticsByCurrentCity());
      await filteredOpticShopsStreamed.content(_getShopsByFilters());
    } on DioError catch (e) {
      ex = CustomException(
        title: 'Ошибка при отправке запроса на сервер',
        subtitle: e.message,
        ex: e,
      );
      unawaited(filteredOpticShopsStreamed.error(ex));
    } on ResponseParseException catch (e) {
      ex = CustomException(
        title: 'Ошибка при получении ответа с сервера',
        subtitle: e.toString(),
        ex: e,
      );
      unawaited(filteredOpticShopsStreamed.error(ex));
    } on SuccessFalse catch (e) {
      ex = CustomException(
        title: 'Произошла ошибка',
        subtitle: e.toString(),
        ex: e,
      );
      unawaited(filteredOpticShopsStreamed.error(ex));
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      ex = CustomException(
        title: 'Произошла ошибка',
        subtitle: e.toString(),
      );
      unawaited(filteredOpticShopsStreamed.error(ex));
    }
  }

  List<OpticCity> _sort(List<OpticCity> cities) {
    if (cities.isEmpty) return [];
    return cities..sort((a, b) => a.title.compareTo(b.title));
  }
}
