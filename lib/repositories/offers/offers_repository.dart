import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/models/offer/offer.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';

class OffersRepository {
  final List<Offer> offerList;

  OffersRepository({
    required this.offerList,
  });

  factory OffersRepository.fromList(List<dynamic> list) {
    return OffersRepository(
      offerList: list
          .map(
            // ignore: avoid_annotating_with_dynamic
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

    final res = BaseResponseRepository.fromMap(
      (await rh.get<Map<String, dynamic>>(
        '/banner/',
        queryParameters: <String, dynamic>{
          'type': type,
          'good': goodID,
        },
      ))
          .data!,
    );

    return OffersRepository.fromList(res.data as List<dynamic>);
  }
}
