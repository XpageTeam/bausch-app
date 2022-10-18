import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/models/catalog_item/catalog_item_model.dart';

class ConsultationItemModel extends CatalogItemModel {
  //* Продолжительность консультации в минутах
  final int? length;

  final String? partnerLink;
  final String? promoCodeEndDate;

  ConsultationItemModel({
    required int id,
    required String name,
    required String previewText,
    required String detailText,
    required String? picture,
    required int price,
    this.partnerLink,
    this.promoCodeEndDate,
    // required this.poolPromoCode,
    // required this.staticPromoCode,
    this.length,
    String? type,
  }) : super(
          id: id,
          name: name,
          previewText: previewText,
          detailText: detailText,
          picture: picture,
          price: price,
          type: type,
          disclaimer: '',
        );

  factory ConsultationItemModel.fromMap(Map<String, dynamic> map) {
    if (map['id'] == null) {
      throw ResponseParseException('Не передан идентификатор');
    }

    if (map['name'] == null) {
      throw ResponseParseException('Не передано название товара');
    }

    if (map['preview_text'] == null) {
      throw ResponseParseException('Не передан превью текст');
    }

    if (map['detail_text'] == null) {
      throw ResponseParseException('Не передан детаил текст');
    }
    if (map['price'] == null) {
      throw ResponseParseException('Не передана цена товара');
    }

    try {
      return ConsultationItemModel(
        id: map['id'] as int,
        name: map['name'] as String,
        previewText: map['preview_text'] as String,
        detailText: map['detail_text'] as String,
        picture: map['picture'] as String?,
        price: map['price'] as int,
        // length: map['length'] as int?,
        // poolPromoCode: map['pool_promo_code'] as String,
        // staticPromoCode: map['static_promo_code'] as String,
        partnerLink: map['partner_link'] as String?,
        promoCodeEndDate: map['promo_code_end_date'] as String?,
      );

      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      throw ResponseParseException(e.toString());
    }
  }
}
