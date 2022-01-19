// ignore_for_file: avoid_catches_without_on_clauses

import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/models/catalog_item/catalog_item_model.dart';

class PartnersItemModel extends CatalogItemModel {
  final String? poolPromoCode;
  final String? staticPromoCode;
  final String? link;
  final String? endDate;
  final bool isBought;

  PartnersItemModel({
    required int id,
    required String name,
    required String previewText,
    required String detailText,
    required String? picture,
    required int price,
    this.endDate,
    this.poolPromoCode,
    this.staticPromoCode,
    this.link,
    this.isBought = false,
    String? type,
  }) : super(
          id: id,
          name: name,
          previewText: previewText,
          detailText: detailText,
          picture: picture,
          price: price,
          type: type,
        );

  factory PartnersItemModel.fromMap(Map<String, dynamic> map) {
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
      return PartnersItemModel(
        id: map['id'] as int,
        name: map['name'] as String,
        previewText: map['preview_text'] as String,
        detailText: map['detail_text'] as String,
        picture: map['picture'] as String?,
        price: map['price'] as int,
        poolPromoCode: map['pool_promo_code'] as String?,
        staticPromoCode: map['static_promo_code'] as String?,
        link: map['partner_link'] as String?,
        endDate: map['promo_code_end_date'] as String?,
        isBought: map['isBought'] as bool? ?? false,

      );
    } catch (e) {
      throw ResponseParseException('PartnersItemModel: $e');
    }
  }
}
