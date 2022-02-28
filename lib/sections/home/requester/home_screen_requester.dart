// ignore_for_file: avoid_annotating_with_dynamic, avoid_catches_without_on_clauses

import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/models/sheets/base_catalog_sheet_model.dart';
import 'package:bausch/models/sheets/catalog_sheet_model.dart';
import 'package:bausch/models/sheets/catalog_sheet_with_logos.dart';
import 'package:bausch/models/sheets/catalog_sheet_without_logos_model.dart';
import 'package:bausch/models/stories/story_model.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:bausch/static/static_data.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

class HomeScreenRequester {
  final _rh = RequestHandler();

  // final prefs = SharedPreferences.getInstance();

  /// Загружает сторисы
  Future<List<StoryModel>> loadStories() async {
    final parsedData = BaseResponseRepository.fromMap(
      (await _rh.get<Map<String, dynamic>>('/stories/')).data!,
    );

    // final _prefs = await prefs;

    return (parsedData.data as List<dynamic>).map((dynamic e) {
      return StoryModel.fromMap(e as Map<String, dynamic>);
    }).toList();

    // items = items..removeWhere((element) => element == null);

    // return items;
  }

  Future<List<BaseCatalogSheetModel>> loadCatalog() async {
    final parsedData = BaseResponseRepository.fromMap(
      (await _rh.get<Map<String, dynamic>>(
        'catalog/sections/',
        options: _rh.cacheOptions
            ?.copyWith(
              maxStale: const Nullable(Duration(hours: 5)),
              policy: CachePolicy.request,
            )
            .toOptions(),
      ))
          .data!,
    );

    try {
      return (parsedData.data as List<dynamic>).map((dynamic sheet) {
        if ((sheet as Map<String, dynamic>)
            .containsValue(StaticData.types['discount_optics'])) {
          return CatalogSheetWithLogosModel.fromMap(
            sheet,
          );
        } else if (sheet.containsValue(StaticData.types['consultation'])) {
          return CatalogSheetWithoutLogosModel.fromMap(sheet);
        } else {
          return CatalogSheetModel.fromMap(sheet);
        }
      }).toList();
    } catch (e) {
      throw ResponseParseException('loadCatalog: $e');
    }
  }
}
