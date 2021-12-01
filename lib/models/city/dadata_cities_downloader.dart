import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

/// загрузчик списка городов страны
class CitiesDownloader {
  /// Возвращает содержимое csv файла с сервера
  static Future<BaseResponseRepository> loadCities() async {
    final rh = RequestHandler();

    return BaseResponseRepository.fromMap((await rh.get<Map<String, dynamic>>(
      '/static/cities/',
      options: rh.cacheOptions?.copyWith(
        maxStale: const Duration(days: 10),
        policy: CachePolicy.request,
      ).toOptions(),
    )).data!);
  }
}
