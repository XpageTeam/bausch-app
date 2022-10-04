import 'dart:async';
import 'dart:developer';

import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/exceptions/success_false.dart';
import 'package:bausch/models/city/dadata_cities_downloader.dart';
import 'package:bausch/models/dadata/dadata_response_data_model.dart';
import 'package:bausch/models/shop/filter_model.dart';
import 'package:bausch/repositories/shops/shops_repository.dart';
import 'package:bausch/sections/profile/profile_settings/screens/city/city_screen.dart';
import 'package:bausch/sections/select_optic/certificate_filter_screen.dart';
import 'package:bausch/sections/select_optic/certificate_optics_loader.dart';
import 'package:bausch/sections/select_optic/widgets/certificate_filter_section/certificate_filter_section_model.dart';
import 'package:bausch/sections/select_optic/widgets/choose_types_sheet.dart';
import 'package:bausch/sections/sheets/screens/discount_optics/widget_models/discount_optics_screen_wm.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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

  final certificateFilterSectionModelState =
      StreamedState<CertificateFilterSectionModel?>(
    null,
    // CertificateFilterSectionModel(
    //   commonFilters: const [
    //     CommonFilter(
    //       id: 0,
    //       title: 'Скидка после подбора',
    //       xmlId: 'sale',
    //     ),
    //     CommonFilter(
    //       id: 1,
    //       title: '1 Скидка после подбора',
    //       xmlId: 'sale_1',
    //     ),
    //     CommonFilter(
    //       id: 2,
    //       title: '2 Скидка после подбора',
    //       xmlId: 'sale_2',
    //     ),
    //   ],
    //   lensFilters: const [
    //     LensFilter(
    //       id: 0,
    //       title: 'Сферические',
    //       color: AppTheme.turquoiseBlue,
    //       xmlId: 'sph',
    //     ),
    //     LensFilter(
    //       id: 1,
    //       title: 'Мультифокальные',
    //       subtitle: 'Пресбиопия',
    //       color: AppTheme.yellowMultifocal,
    //       xmlId: 'multi',
    //     ),
    //     LensFilter(
    //       id: 2,
    //       title: 'Торические',
    //       subtitle: 'Астигматизм',
    //       color: AppTheme.orangeToric,
    //       xmlId: 'toric',
    //     ),
    //   ],
    // ),
  );

  /// Для карты с сертификатами. Содержит выбранные фильтры для линз
  final selectedLensFiltersState = StreamedState<List<LensFilter>>([]);

  /// Для карты с сертификатами. Содержит выбранные общие фильтры
  final selectedCommonFiltersState = StreamedState<List<CommonFilter>>([]);

  /// Для карты с сертификатами. Содержит количество всех выбранных фильтров
  final selectedFiltersCountState = StreamedState<int>(0);

  final String? initialCity;

  List<OpticCity> cities = [];

  List<OpticShopForCertificate> opticShopsForCertificate = [];

  List<OpticCity> initialCities;
  List<Filter> selectedFilters = [];
  bool isCertificateMap;

  SelectOpticScreenWM({
    required this.context,
    required this.isCertificateMap,
    this.initialCities = const [],
    this.initialCity,
  }) : super(
          const WidgetModelDependencies(),
        );

  @override
  Future<void> onLoad() async {
    // _initCurrentCity();
    await _loadCities();
    if (isCertificateMap) {
      await _loadCertificateFiltersModel();

      if (initialCities.isEmpty) {
        await _loadOptics();
      }

      await currentCityStreamed.content(initialCity ?? '');
      final shops = await _getCertificateShopsByCurrentCity();
      await filteredOpticShopsStreamed.content(shops);
    } else {
      if (initialCities.isEmpty) {
        unawaited(_loadOptics());
      } else {
        initialCities = _sort(initialCities);

        await currentCityStreamed.content(initialCity ?? '');

        if (initialCity == null) {
          final optics = initialCities.fold<List<Optic>>(
            [],
            (previousValue, element) => previousValue
              ..addAll(
                element.optics,
              ),
          );
          await opticsByCityStreamed.accept(optics);
          final shops = optics.fold<List<OpticShop>>(
            [],
            (previousValue, element) => previousValue..addAll(element.shops),
          ).toList();

          await filteredOpticShopsStreamed.content(shops);
        } else {
          final opticsByCurrentCity = await _getOpticsByCurrentCity();

          await opticsByCityStreamed.accept(opticsByCurrentCity);
          await filteredOpticShopsStreamed.content(
            _getShopsByFilters(opticsByCurrentCity),
          );
        }
      }
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

    filtersOnChanged.bind(
      (selectedFilters) => _filtersOnChanged(selectedFilters!),
    );

    onOpticShopSelectAction.bind(
      (opticShopParams) => _onOpticShopSelect(opticShopParams!),
    );

    selectedLensFiltersState.stream.listen(
      (_) => _recalculationSelectedFilters(),
    );
    selectedCommonFiltersState.stream.listen(
      (_) => _recalculationSelectedFilters(),
    );

    super.onBind();
  }

  Future<void> onCityDefinition(DadataResponseDataModel dataModel) async {
    if (initialCities.any(
          (opticCity) => dataModel.city == opticCity.title,
        ) &&
        currentCityStreamed.value.data != dataModel.city) {
      // Тут проверки на нулл нет, т.к. она внутри метода, который запускает этот коллбэк
      await _updateCity(dataModel.city!);
    }
  }

  Future<void> onCommonFilterTap(CommonFilter newFilter) async {
    final filters = selectedCommonFiltersState.value.toList();

    if (filters.any((filter) => newFilter == filter)) {
      filters.remove(newFilter);
    } else {
      filters.add(newFilter);
    }

    // debugPrint('filters: $filters');

    await selectedCommonFiltersState.accept(filters);
    filteredOpticShopsStreamed.content(
      _filterOpticShopsForCertificate(),
    );
  }

  Future<void> onLensFilterTap(LensFilter newFilter) async {
    final filters = selectedLensFiltersState.value;

    if (filters.any((filter) => newFilter == filter)) {
      filters.remove(newFilter);
    } else {
      filters.add(newFilter);
    }

    await selectedLensFiltersState.accept(filters);

    filteredOpticShopsStreamed.content(
      _filterOpticShopsForCertificate(),
    );
  }

  Future<void> resetLensFilters() async {
    await selectedLensFiltersState.accept([]);
    filteredOpticShopsStreamed.content(
      _filterOpticShopsForCertificate(),
    );
  }

  Future<void> resetCommonFilters() async {
    await selectedCommonFiltersState.accept([]);
    filteredOpticShopsStreamed.content(
      _filterOpticShopsForCertificate(),
    );
  }

  void resetAllFilters() {
    resetLensFilters();
    resetCommonFilters();
  }

  void showLensFiltersBottomsheet() {
    showModalBottomSheet<num>(
      isScrollControlled: true,
      context: context,
      barrierColor: Colors.black.withOpacity(0.8),
      builder: (_) => ChooseTypesSheet(wm: this),
    );
  }

  void openAllCertificateFilters() {
    Navigator.of(context).push(
      PageRouteBuilder<String>(
        pageBuilder: (_, __, ___) => CertificateFilterScreen(wm: this),
      ),
    );
  }

  OpticShop? selectedOpticShop;

  void shopOpticOnMap(OpticShop shop) {
    selectedOpticShop = shop;

    _switchPage(SelectOpticPage.map);
  }

  List<OpticShopForCertificate> _filterOpticShopsForCertificate() {
    if (selectedLensFiltersState.value.isEmpty &&
        selectedCommonFiltersState.value.isEmpty) {
      return opticShopsForCertificate;
    }

    return opticShopsForCertificate
        .where(
          (opticShop) => opticShop.features.any(
            (feature) =>
                selectedLensFiltersState.value.any(
                  (filter) => filter.xmlId == feature.xmlId,
                ) ||
                selectedCommonFiltersState.value.any(
                  (filter) => filter.xmlId == feature.xmlId,
                ),
          ),
        )
        .toList();
  }

  Future<void> _updateCity(String cityName) async {
    await currentCityStreamed.content(cityName);

    if (isCertificateMap) {
      opticShopsForCertificate = await _getCertificateShopsByCurrentCity();

      await filteredOpticShopsStreamed.content(opticShopsForCertificate);
    } else {
      final opticsByCurrentCity = await _getOpticsByCurrentCity();
      final shopsByFilters = _getShopsByFilters(opticsByCurrentCity);

      await opticsByCityStreamed.accept(
        opticsByCurrentCity,
      );
      await filteredOpticShopsStreamed.content(
        shopsByFilters,
      );
    }
  }

  Future<void> _switchPage(SelectOpticPage newPage) async {
    if (currentPageStreamed.value != newPage) {
      await currentPageStreamed.accept(newPage);
    }
  }

  void _onOpticShopSelect(OpticShopParams params) {
    for (final city in initialCities) {
      for (final optic in city.optics) {
        if (optic.shops.any(
          (shop) => shop.coords == params.selectedShop.coords,
        )) {
          params.callback(optic, params.selectedShop);
          return;
        }
      }
    }
  }

  Future<void> _filtersOnChanged(List<Filter> newSelectedFilters) async {
    selectedFilters = newSelectedFilters;
    final optics = initialCities.fold<List<Optic>>(
      [],
      (previousValue, element) => previousValue
        ..addAll(
          element.optics,
        ),
    );

    final shopsByFilters = _getShopsByFilters(
      currentCityStreamed.value.data == null ||
              currentCityStreamed.value.data!.isEmpty
          ? optics
          : await _getOpticsByCurrentCity(),
    );
    await filteredOpticShopsStreamed.content(shopsByFilters);
  }

  void _recalculationSelectedFilters() {
    final lensFiltersCount = selectedLensFiltersState.value.length;
    final commonFiltersCount = selectedCommonFiltersState.value.length;
    selectedFiltersCountState.accept(lensFiltersCount + commonFiltersCount);
  }

  Future<void> _loadCertificateFiltersModel() async {
    CustomException? exception;
    try {
      final filtersSectionModel = await CertificateOpticsLoader.loadFilters();
      await certificateFilterSectionModelState.accept(filtersSectionModel);
    } on DioError catch (e) {
      exception = CustomException(
        title: 'При загрузке списка городов произошла ошибка',
        subtitle: e.message,
        ex: e,
      );
    } on ResponseParseException catch (e) {
      exception = CustomException(
        title: 'При обработке ответа от сервера произошла ошибка',
        subtitle: e.toString(),
        ex: e,
      );
    } on SuccessFalse catch (e) {
      exception = CustomException(
        title: e.toString(),
        ex: e,
      );
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      exception = CustomException(
        title: 'Произошла ошибка',
        subtitle: e.toString(),
        ex: Exception(e),
      );
    }
    if (exception != null) {
      log(
        'Exception',
        error: exception,
      );
    }
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
          citiesWithShops: initialCities.map((e) => e.title).toList(),
          withFavoriteItems:
              initialCities.map((e) => e.title).toList().contains('Москва')
                  ? ['Москва']
                  : [],
        ),
      ),
    );

    if (cityName != null && cityName != currentCityStreamed.value.data) {
      await _updateCity(cityName);
    }
  }

  Future<List<OpticShopForCertificate>>
      _getCertificateShopsByCurrentCity() async {
    if (cities
        .any((element) => element.title == currentCityStreamed.value.data)) {
      final cityId = cities
          .firstWhere(
            (element) => element.title == currentCityStreamed.value.data,
          )
          .id!;
      debugPrint('cityId: $cityId');

      /// Загрузка оптик
      return CertificateOpticsLoader.loadByCityId(cityId);
    }
    return [];
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

    if (initialCities.isEmpty) {
      await _loadOptics();
    }

    if (initialCities.any(_equalsCurrentCity)) {
      optics = initialCities.firstWhere(_equalsCurrentCity).optics;
    } else {
      final splittedCurrentCity = currentCity.split(' ');

      for (final piece in splittedCurrentCity) {
        if (initialCities.any(
          (city) => _equalsPieceOrWithComma(city, piece),
        )) {
          optics = initialCities
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

  Future<void> _loadCities() async {
    CustomException? exception;
    try {
      cities = await _parseCityList(
        (await CitiesDownloader().loadCities()).data as List<dynamic>,
      );
    } on DioError catch (e) {
      exception = CustomException(
        title: 'При загрузке списка городов произошла ошибка',
        subtitle: e.message,
        ex: e,
      );
    } on ResponseParseException catch (e) {
      exception = CustomException(
        title: 'При обработке ответа от сервера произошла ошибка',
        subtitle: e.toString(),
        ex: e,
      );
    } on SuccessFalse catch (e) {
      exception = CustomException(
        title: e.toString(),
        ex: e,
      );
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      exception = CustomException(
        title: 'Произошла ошибка',
        subtitle: e.toString(),
        ex: Exception(e),
      );
    }
    if (exception != null) {
      log(
        'Exception',
        error: exception,
      );
    }
  }

  Future<List<OpticCity>> _parseCityList(List<dynamic> rawCityList) async {
    final cities = rawCityList
        // ignore: avoid_annotating_with_dynamic
        .map((dynamic e) {
      final map = e as Map<String, dynamic>;

      return OpticCity(
        id: map['id'] as int,
        title: map['name'] as String,
        optics: [],
      );
    }).toList();
    return cities;
  }

  Future<void> _loadOptics() async {
    CustomException? ex;

    try {
      final opticCititesRepository =
          OpticCititesRepository.fromCitiesRepository(
        await AllOpticsDownloader.load(),
      );

      initialCities = _sort(opticCititesRepository.cities);

      if (initialCity == null) {
        await currentCityStreamed.content(initialCities.first.title);
      } else {
        await currentCityStreamed.content(initialCity!);
      }

      final opticsByCurrentCity = await _getOpticsByCurrentCity();
      final shopsByFilters = _getShopsByFilters(opticsByCurrentCity);

      await opticsByCityStreamed.accept(opticsByCurrentCity);
      await filteredOpticShopsStreamed.content(
        shopsByFilters,
        // ..add(
        //   OpticShop(
        //     title: 'title',
        //     phones: ['phones'],
        //     address: 'address',
        //     city: 'city',
        //     coords: Point(
        //       latitude: 55.160602,
        //       longitude: 61.387938,
        //     ),
        //   ),
        // )
        // ..add(
        //   OpticShop(
        //     title: 'title',
        //     phones: ['phones'],
        //     address: 'address',
        //     city: 'city',
        //     coords: Point(
        //       latitude: 55.158508,
        //       longitude: 61.410800,
        //     ),
        //   ),
        // ),
      );
    } on DioError catch (e) {
      ex = CustomException(
        title: 'Ошибка при отправке запроса',
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
    OpticCity? moscow;

    if (cities.any((city) => city.title == 'Москва')) {
      moscow = cities.firstWhere((city) => city.title == 'Москва');
      cities.remove(moscow);
    }
    final sortedCities = cities..sort((a, b) => a.title.compareTo(b.title));

    return [
      if (moscow != null) moscow,
      ...sortedCities,
    ];
  }
}
