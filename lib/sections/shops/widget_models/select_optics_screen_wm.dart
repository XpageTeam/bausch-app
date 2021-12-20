import 'dart:async';

import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/exceptions/success_false.dart';
import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/models/discount_optic/discount_optic.dart';
import 'package:bausch/models/shop/filter_model.dart';
import 'package:bausch/repositories/shops/shops_repository.dart';
import 'package:bausch/sections/profile/profile_settings/screens/city/city_screen.dart';
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

  final opticsStreamed = EntityStreamedState<List<DiscountOptic>>();
  final currentCityStreamed = EntityStreamedState<String>();
  final contentTypeStreamed = StreamedState<ShopsContentType>(
    ShopsContentType.map,
  );
  final selectedFiltersStreamed = StreamedState<List<Filter>>([]);

  final switchAction = StreamedAction<ShopsContentType>();
  final selectCityAction = VoidAction();
  final filtersOnChanged = StreamedAction<List<Filter>>();

  List<DiscountOptic>? initialOptics;

  SelectOpticScreenWM({
    required this.context,
    required this.initialOptics,
  }) : super(
          const WidgetModelDependencies(),
        );

  @override
  void onLoad() {
    _initCurrentCity();
    if (initialOptics == null) {
      _loadOptics();
      initialOptics = opticsStreamed.value.data;
    } else {
      opticsStreamed.content(initialOptics!);
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

    filtersOnChanged.bind(
      (selectedFilters) => _filtersOnChanged(selectedFilters!),
    );

    super.onBind();
  }

  void _filtersOnChanged(List<Filter> selectedFilters) {
    final filteredCityList = initialOptics!
        .where(
          (optic) => selectedFilters.any(
            (filter) => filter.title == optic.title,
          ),
        )
        .toList();

    opticsStreamed.content(
      filteredCityList,
    );
  }

  Future<void> _selectCity() async {
    final cityName = await Keys.mainNav.currentState!.push<String>(
      PageRouteBuilder<String>(
        pageBuilder: (context, animation, secondaryAnimation) => CityScreen(),
      ),
    );

    if (cityName != currentCityStreamed.value.data) {
      unawaited(currentCityStreamed.content(cityName!));
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

  Future<void> _loadOptics() async {
    try {
      // TODO(Nikolay): Тут должен быть другой метод.
      // final citiesRepository = await AllOpticsDownloader.load();
      // unawaited(
      //   opticsStreamed.content(
      //     citiesRepository.cities,
      //   ),
      // );
    } on DioError catch (e) {
      unawaited(
        opticsStreamed.error(
          CustomException(
            title: 'Ошибка при отправке запроса на сервер',
            subtitle: e.message,
            ex: e,
          ),
        ),
      );
    } on ResponseParseException catch (e) {
      unawaited(
        opticsStreamed.error(
          CustomException(
            title: 'Ошибка при получении ответа с сервера',
            subtitle: e.toString(),
            ex: e,
          ),
        ),
      );
    } on SuccessFalse catch (e) {
      unawaited(
        opticsStreamed.error(
          CustomException(
            title: 'Произошла ошибка',
            subtitle: e.toString(),
            ex: e,
          ),
        ),
      );
    }
  }

  List<CityModel>? _sort(List<CityModel> cities) {
    if (cities.isEmpty) return null;
    return cities..sort((a, b) => a.name.compareTo(b.name));
  }
}
