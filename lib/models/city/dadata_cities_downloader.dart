// ignore_for_file: avoid_catches_without_on_clauses, avoid_annotating_with_dynamic

import 'dart:convert';

import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/models/dadata/dadata_response_model.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:bausch/static/static_data.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

import 'package:http/http.dart' as http;

/// загрузчик списка городов страны
class CitiesDownloader {
  final _rh = RequestHandler();

  /// Возвращает содержимое csv файла с сервера
  Future<BaseResponseRepository> loadCities() async {
    return BaseResponseRepository.fromMap(
      (await _rh.get<Map<String, dynamic>>(
        '/static/cities/',
        options: _rh.cacheOptions
            ?.copyWith(
              maxStale: const Duration(days: 10),
              policy: CachePolicy.request,
            )
            .toOptions(),
      ))
          .data!,
    );
  }

  Future<List<DadataResponseModel>> loadDadataCities(String query) async {
    try {
      final result = await http.post(
        Uri.parse(
          'https://suggestions.dadata.ru/suggestions/api/4_1/rs/suggest/address',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Token ${StaticData.dadataApiKey}',
        },
        body: json.encode(
          {
            'query': query,
            'count': 15,
            // 'locations': [
            //   {'city': city},
            //   // {"street": userText}
            // ],
            // 'from_bound': {'value': ''},
            'to_bound': {'value': 'settlement'},
          },
        ),
      );

      return ((json.decode(result.body) as Map<String, dynamic>)['suggestions']
              as List<dynamic>)
          .map((dynamic e) =>
              DadataResponseModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ResponseParseException(e.toString());
    }
  }
}
