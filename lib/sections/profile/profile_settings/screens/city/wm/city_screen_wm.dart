import 'dart:async';

import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/exceptions/success_false.dart';
import 'package:bausch/models/city/dadata_cities_downloader.dart';
import 'package:bausch/models/city/dadata_city.dart';
import 'package:csv/csv.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class CityScreenWM extends WidgetModel {
  final citiesList = EntityStreamedState<List<DadataCity>>();

  final citiesListReloadAction = VoidAction();

  final citiesFilterController = TextEditingController();
  final filteredCitiesList = StreamedState<List<DadataCity>>([]);

  CityScreenWM(WidgetModelDependencies baseDependencies)
      : super(baseDependencies) {
    _loadCities();
  }

  @override
  void onLoad() {
    subscribe(citiesListReloadAction.stream, (value) {
      _loadCities();
    });

    subscribe(citiesList.stream, (value) {
      if (citiesList.value.data != null) {
        _filterCities();
      }
    });

    citiesFilterController.addListener(_filterCities);

    super.onLoad();
  }

  Future<void> _loadCities() async {
    if (citiesList.value.isLoading) return;

    unawaited(citiesList.loading());

    try {
      final parsedCities = const CsvToListConverter(
        eol: '\n',
      ).convert<dynamic>((await CitiesDownloader.loadCities()).data as String);

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

  void _filterCities() {
    final filteredList = <DadataCity>[];

    citiesList.value.data?.forEach((city) {
      if (city.name.toLowerCase().indexOf(citiesFilterController.text.toLowerCase()) == 0) {
        filteredList.add(city);
      }
    });

    filteredCitiesList.accept(filteredList);
  }
}
