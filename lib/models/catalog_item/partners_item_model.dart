import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/models/catalog_item/catalog_item_model.dart';
import 'package:bausch/models/mappable_object.dart';

class PartnersItemModel extends CatalogItemModel
    implements MappableInterface<PartnersItemModel> {
  final String poolPromoCode;
  final String staticPromoCode;
  PartnersItemModel({
    required int id,
    required String name,
    required String previewText,
    required String detailText,
    required String picture,
    required int price,
    required this.poolPromoCode,
    required this.staticPromoCode,
  }) : super(
          id: id,
          name: name,
          previewText: previewText,
          detailText: detailText,
          picture: picture,
          price: price,
        );

  factory PartnersItemModel.fromMap(Map<String, dynamic> map) {
    if (map['id'] == null) {
      throw ResponseParseExeption('Не передан идентификатор');
    }

    if (map['name'] == null) {
      throw ResponseParseExeption('Не передано название товара');
    }

    if (map['preview_text'] == null) {
      throw ResponseParseExeption('Не передан превью текст');
    }

    if (map['detail_text'] == null) {
      throw ResponseParseExeption('Не передан детаил текст');
    }
    if (map['price'] == null) {
      throw ResponseParseExeption('Не передана цена товара');
    }

    return PartnersItemModel(
      id: map['id'] as int,
      name: map['name'] as String,
      previewText: map['preview_text'] as String,
      detailText: map['detail_text'] as String,
      picture:
          'https://ryady.ru/upload/resize_cache/iblock/6c2/600_600_1/000000000000060033_0.jpg',
      price: (map['price'] ?? 150) as int,
      poolPromoCode: map['pool_promo_code'] as String,
      staticPromoCode: map['static_promo_code'] as String,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    throw UnimplementedError();
  }
}
