import 'dart:async';

import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/exceptions/success_false.dart';
import 'package:bausch/models/city/dadata_cities_downloader.dart';
import 'package:bausch/models/city/dadata_city.dart';
import 'package:bausch/models/dadata/dadata_response_model.dart';
import 'package:csv/csv.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class CityScreenWM extends WidgetModel {
  final List<String>? citiesWithShops;

  final citiesList = EntityStreamedState<List<DadataCity>>();
  final daDataCitiesList = EntityStreamedState<List<DadataResponseModel>>();

  final citiesListReloadAction = VoidAction();
  final selectCityAction = VoidAction();

  final confirmAction = StreamedAction<DadataResponseModel>();

  final citiesFilterController = TextEditingController();
  final filteredCitiesList = StreamedState<List<DadataCity>>([]);

  final isSearchActive = StreamedState<bool>(false);
  final canCompleteSearch = StreamedState<bool>(false);
  final searchQuery = StreamedState<String>('');

  final BuildContext context;

  final _requester = CitiesDownloader();

  CityScreenWM(
    WidgetModelDependencies baseDependencies, {
    required this.context,
    this.citiesWithShops,
  }) : super(baseDependencies) {
    if (citiesWithShops == null) {
      _loadCities();
    } else {
      // Это используется для карты
      citiesList.content(
        citiesWithShops!
            .map(
              (e) => DadataCity(
                kladrID: 'kladrID',
                fiasID: 'fiasID',
                postalCode: 'postalCode',
                fiasLevel: 'fiasLevel',
                timezone: 'timezone',
                cityType: 'cityType',
                name: e,
                regionType: 'regionType',
                regionName: 'regionName',
                address: 'address',
              ),
            )
            .toList(),
      );
    }
  }

  @override
  void dispose() {
    citiesFilterController.dispose();

    super.dispose();
  }

  @override
  void onLoad() {
    subscribe<DadataResponseModel>(confirmAction.stream, (item) {
      if (item.value != citiesFilterController.text) {
        citiesFilterController
          ..text = item.value
          ..selection = TextSelection.fromPosition(
            TextPosition(offset: citiesFilterController.text.length),
          );

        if (item.data.city != null || item.data.settlement != null) {
          canCompleteSearch.accept(true);
        }

        searchQuery.accept(item.value);
      }
    });

    subscribe(selectCityAction.stream, (_) {
      Navigator.of(context).pop(searchQuery.value);
    });

    subscribe(citiesListReloadAction.stream, (value) {
      _loadCities();
    });

    subscribe(citiesList.stream, (value) {
      if (citiesList.value.data != null) {
        _filterCities();
      }
    });

    citiesFilterController.addListener(() {
      if (citiesWithShops == null) {
        if (citiesFilterController.text != '') {
          isSearchActive.accept(true);
          _filterCities();
        } else {
          canCompleteSearch.accept(false);
          isSearchActive.accept(false);
        }
      } else {
        _filterCities();
      }

      if (citiesFilterController.text != searchQuery.value &&
          citiesWithShops == null) {
        canCompleteSearch.accept(false);
      }
    });

    super.onLoad();
  }

  Future<void> _loadCities() async {
    if (citiesList.value.isLoading) return;

    unawaited(citiesList.loading());

    try {
      final parsedCities = const CsvToListConverter(
        eol: '\n',
      ).convert<dynamic>((await _requester.loadCities()).data as String);

      final cities = parsedCities.map((item) {
        return DadataCity.fromCSV(item);
      }).toList();

      await citiesList.content(cities);
    } on DioError catch (e) {
      await citiesList.error(
        CustomException(
          title: 'При загрузке списка городов произошла ошибка',
          subtitle: e.message,
          ex: e,
        ),
      );
    } on ResponseParseException catch (e) {
      await citiesList.error(
        CustomException(
          title: 'При обработке ответа от сервера произошла ошибка',
          subtitle: e.toString(),
          ex: e,
        ),
      );
    } on SuccessFalse catch (e) {
      await citiesList.error(
        CustomException(
          title: e.toString(),
          ex: e,
        ),
      );
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      await citiesList.error(
        CustomException(
          title: 'Произошла ошибка',
          subtitle: e.toString(),
          ex: Exception(e),
        ),
      );
    }
  }

  Future<void> _filterCities() async {
    /// если введён поисковый запрос
    if (citiesWithShops == null && citiesFilterController.text != '') {
      if (daDataCitiesList.value.isLoading) return;

      unawaited(daDataCitiesList.loading(daDataCitiesList.value.data));

      try {
        await daDataCitiesList.content(
          await _requester.loadDadataCities(citiesFilterController.text),
        );
      } on DioError catch (e) {
        await citiesList.error(
          CustomException(
            title: 'При загрузке списка городов произошла ошибка',
            subtitle: e.message,
            ex: e,
          ),
        );
      } on ResponseParseException catch (e) {
        await citiesList.error(
          CustomException(
            title: 'При обработке ответа от сервера произошла ошибка',
            subtitle: e.toString(),
            ex: e,
          ),
        );
      } on SuccessFalse catch (e) {
        await citiesList.error(
          CustomException(
            title: e.toString(),
            ex: e,
          ),
        );
        // ignore: avoid_catches_without_on_clauses
      } catch (e) {
        await citiesList.error(
          CustomException(
            title: 'При загрузке списка городов произошла ошибка',
            subtitle: e.toString(),
          ),
        );
      }

      return;
    }

    final filteredList = <DadataCity>[];

    citiesList.value.data?.forEach((city) {
      if (city.name
              .toLowerCase()
              .indexOf(citiesFilterController.text.toLowerCase()) ==
          0) {
        filteredList.add(city);
      }
    });

    await filteredCitiesList.accept(filteredList);
  }
}
