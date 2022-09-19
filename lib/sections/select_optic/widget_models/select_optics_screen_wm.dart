import 'dart:async';

import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/exceptions/success_false.dart';
import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/models/dadata/dadata_response_data_model.dart';
import 'package:bausch/models/shop/filter_model.dart';
import 'package:bausch/repositories/shops/shops_repository.dart';
import 'package:bausch/sections/profile/profile_settings/screens/city/city_screen.dart';
import 'package:bausch/sections/sheets/screens/discount_optics/widget_models/discount_optics_screen_wm.dart';
import 'package:bausch/static/static_data.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

enum SelectOpticPage {
  map,
  list,
}

extension ShopsContentTypeAsString on SelectOpticPage {
  String get asString => this == SelectOpticPage.map ? 'На карте' : 'Список';
}

class OpticShopParams {
  final OpticShop selectedShop;
  final void Function(Optic optic, OpticShop? shop) callback;

  OpticShopParams(this.selectedShop, this.callback);
}

class SelectOpticScreenWM extends WidgetModel {
  final BuildContext context;

  final filteredOpticShopsStreamed = EntityStreamedState<List<OpticShop>>();
  final opticsByCityStreamed = StreamedState<List<Optic>>([]);
  final currentCityStreamed = EntityStreamedState<String>();

  final currentPageStreamed = StreamedState<SelectOpticPage>(
    SelectOpticPage.map,
  );

  final switchAction = StreamedAction<SelectOpticPage>();
  final setFirstCity = VoidAction();
  final selectCityAction = VoidAction();
  final filtersOnChanged = StreamedAction<List<Filter>>();
  final onOpticShopSelectAction = StreamedAction<OpticShopParams>();

  List<OpticCity>? initialCities;
  List<Filter> selectedFilters = [];

  SelectOpticScreenWM({
    required this.context,
    this.initialCities,
  }) : super(
          const WidgetModelDependencies(),
        );

  @override
  Future<void> onLoad() async {
    // _initCurrentCity();
    if (initialCities == null) {
      unawaited(_loadOptics());
    } else {
      initialCities = _sort(initialCities!);

      final haveMoscow =
          initialCities!.where((element) => element.title == 'Москва').length;

      if (haveMoscow > 0 &&
          Provider.of<UserWM>(
                context,
                listen: false,
              ).userData.value.data?.user.city !=
              null) {
        // ignore: unawaited_futures
        currentCityStreamed.content(Provider.of<UserWM>(
          context,
          listen: false,
        ).userData.value.data!.user.city!);
      } else {
        await currentCityStreamed.content(initialCities!.first.title);
      }

      final opticsByCurrentCity = await _getOpticsByCurrentCity();

      await opticsByCityStreamed.accept(opticsByCurrentCity);
      await filteredOpticShopsStreamed.content(
        _getShopsByFilters(opticsByCurrentCity),
      );
    }

    super.onLoad();
  }

  @override
  void onBind() {
    switchAction.bind(
      (newType) => _switchPage(newType!),
    );

    selectCityAction.bind(
      (_) => _selectCity(),
    );

    // setFirstCity.bind(
    //   (_) => _setFirstCity(),
    // );

    filtersOnChanged.bind(
      (selectedFilters) => _filtersOnChanged(selectedFilters!),
    );

    onOpticShopSelectAction.bind(
      (opticShopParams) => _onOpticShopSelect(opticShopParams!),
    );

    super.onBind();
  }

  Future<void> onCityDefinition(DadataResponseDataModel dataModel) async {
    if (initialCities != null &&
        initialCities!.any(
          (opticCity) => dataModel.city == opticCity.title,
        ) &&
        currentCityStreamed.value.data != dataModel.city) {
      // Тут проверки на нулл нет, т.к. она внутри метода, который запускает этот коллбэк
      await _updateCity(dataModel.city!);
    }
  }

  Future<void> _updateCity(String cityName) async {
    await currentCityStreamed.content(cityName);
    await opticsByCityStreamed.accept(await _getOpticsByCurrentCity());
  }

  void _switchPage(SelectOpticPage newPage) {
    if (currentPageStreamed.value != newPage) {
      currentPageStreamed.accept(newPage);
    }
  }

  void _onOpticShopSelect(OpticShopParams params) {
    if (initialCities != null) {
      for (final city in initialCities!) {
        for (final optic in city.optics) {
          if (optic.shops.any(
            (shop) => shop == params.selectedShop,
          )) {
            params.callback(optic, params.selectedShop);
            return;
          }
        }
      }
    }
  }

  Future<void> _filtersOnChanged(List<Filter> newSelectedFilters) async {
    selectedFilters = newSelectedFilters;
    final shopsByFilters = _getShopsByFilters(await _getOpticsByCurrentCity());
    await filteredOpticShopsStreamed.content(shopsByFilters);
  }

  /* Future<void> _setFirstCity() async {
    if (initialCities!.isEmpty) {
      await currentCityStreamed.error(
        const CustomException(
          title: 'Список городов пустой',
        ),
      );
      await opticsByCityStreamed.accept([]);
      await filteredOpticShopsStreamed.content([]);
    } else {
      await currentCityStreamed.content(initialCities!.first.title);
      final opticsByCurrentCity = await _getOpticsByCurrentCity();

      await opticsByCityStreamed.accept(opticsByCurrentCity);
      await filteredOpticShopsStreamed
          .content(_getShopsByFilters(opticsByCurrentCity));
    }
  }*/

  Future<void> _selectCity() async {
    final cityName = await Keys.mainNav.currentState!.push<String>(
      PageRouteBuilder<String>(
        pageBuilder: (context, animation, secondaryAnimation) => CityScreen(
          citiesWithShops: initialCities!.map((e) => e.title).toList(),
          withFavoriteItems:
              initialCities!.map((e) => e.title).toList().contains('Москва')
                  ? null
                  : [],
        ),
      ),
    );

    if (cityName != null && cityName != currentCityStreamed.value.data) {
      await _updateCity(cityName);
    }
  }

  // void _initCurrentCity() {
  //   try {
  //     final authStatus =
  //         Provider.of<AuthWM>(context, listen: false).authStatus.value;

  //     if (authStatus == AuthStatus.authenticated) {
  //       final currentCity = Provider.of<UserWM>(
  //         context,
  //         listen: false,
  //       ).userData.value.data?.user.city;

  //       if (currentCity != null) {
  //         currentCityStreamed.content(currentCity);
  //       } else {
  //         currentCityStreamed.error();
  //       }
  //     }
  //     // ignore: avoid_catches_without_on_clauses
  //   } catch (e) {
  //     currentCityStreamed.error();
  //   }
  // }

  List<OpticShop> _getShopsByFilters(List<Optic> opticsByCity) {
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

  Future<List<Optic>> _getOpticsByCurrentCity() async {
    var optics = <Optic>[];

    final currentCity = currentCityStreamed.value.data?.toLowerCase();
    if (currentCity == null) return optics;

    if (initialCities == null) {
      await _loadOptics();
    }

    if (initialCities!.any(_equalsCurrentCity)) {
      optics = initialCities!.firstWhere(_equalsCurrentCity).optics;
    } else {
      final splittedCurrentCity = currentCity.split(' ');

      for (final piece in splittedCurrentCity) {
        if (initialCities!.any(
          (city) => _equalsPieceOrWithComma(city, piece),
        )) {
          optics = initialCities!
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
    return city.title.toLowerCase() ==
        currentCityStreamed.value.data!.toLowerCase();
  }

  bool _equalsPieceOrWithComma(OpticCity city, String piece) {
    final pieceLower = piece.toLowerCase().replaceAll(',', '');
    final cityLower = city.title.toLowerCase();

    return cityLower == pieceLower;
  }

  Future<void> _loadOptics() async {
    CustomException? ex;

    try {
      final opticCititesRepository =
          OpticCititesRepository.fromCitiesRepository(
        await AllOpticsDownloader.load(),
      );

      initialCities = _sort(opticCititesRepository.cities);

      await currentCityStreamed.content(initialCities!.first.title);

      final opticsByCurrentCity = await _getOpticsByCurrentCity();
      final shopsByFilters = _getShopsByFilters(opticsByCurrentCity);

      await opticsByCityStreamed.accept(opticsByCurrentCity);
      await filteredOpticShopsStreamed.content(shopsByFilters);
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
