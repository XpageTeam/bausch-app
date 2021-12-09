import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/models/offer/offer.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

class OffersRepository {
  final List<Offer> offerList;

  OffersRepository({
    required this.offerList,
  });

  factory OffersRepository.fromList(List<dynamic> list) {
    return OffersRepository(
      offerList: list
          .map(
            (dynamic e) => Offer.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }
}

class OffersRepositoryDownloader {
  static Future<OffersRepository> load({
    required String type,
    int? goodID,
  }) async {
    final rh = RequestHandler();
    final requestString =
        '/banner/?type=$type${goodID != null ? '&good=123' : ''}';

    final res = BaseResponseRepository.fromMap(
      (await rh.get<Map<String, dynamic>>(
        requestString,
        options: rh.cacheOptions
            ?.copyWith(
              maxStale: const Duration(days: 1),
              policy: CachePolicy.request,
            )
            .toOptions(),
      ))
          .data!,
    );

    return OffersRepository.fromList(res.data as List<dynamic>);
  }
}
