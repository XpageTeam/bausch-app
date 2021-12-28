import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/models/catalog_item/catalog_item_model.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

class CatalogItemsRepository {
  final List<CatalogItemModel> items;

  CatalogItemsRepository({
    required this.items,
  });

  factory CatalogItemsRepository.fromList(List<dynamic> list, {String? type}) =>
      CatalogItemsRepository(
        items: list
            .map(
              // ignore: avoid_annotating_with_dynamic
              (dynamic e) => type != null
                  ? CatalogItemModel.itemByTypeFromJson(
                      e as Map<String, dynamic>,
                      type,
                    )
                  : CatalogItemModel.mayBeInterestingItemFromJson(
                      e as Map<String, dynamic>,
                    ),
            )
            .toList(),
      );
}

class InterestingProductsDownloader {
  static Future<CatalogItemsRepository> load() async {
    final rh = RequestHandler();
    final response =
        BaseResponseRepository.fromMap((await rh.get<Map<String, dynamic>>(
      '/catalog/products/interesting/',
      options: rh.cacheOptions
          ?.copyWith(
            maxStale: const Duration(days: 1),
            policy: CachePolicy.request,
          )
          .toOptions(),
    ))
            .data!);

    return CatalogItemsRepository.fromList(
      response.data as List<dynamic>,
    );
  }
}

class ProductsDownloader {
  static Future<CatalogItemsRepository> load(
    String section,
  ) async {
    final rh = RequestHandler();
    final response =
        BaseResponseRepository.fromMap((await rh.get<Map<String, dynamic>>(
      '/catalog/products/',
      queryParameters: <String, dynamic>{
        'section': section,
      },
      options: rh.cacheOptions
          ?.copyWith(
            maxStale: const Duration(days: 1),
            policy: CachePolicy.request,
          )
          .toOptions(),
    ))
            .data!);

    return CatalogItemsRepository.fromList(
      response.data as List<dynamic>,
      type: section,
    );
  }
}
