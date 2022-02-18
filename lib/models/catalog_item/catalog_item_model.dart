// ignore_for_file: avoid_catches_without_on_clauses

import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/help/help_functions.dart';
import 'package:bausch/models/catalog_item/consultattion_item_model.dart';
import 'package:bausch/models/catalog_item/partners_item_model.dart';
import 'package:bausch/models/catalog_item/product_item_model.dart';
import 'package:bausch/models/catalog_item/promo_item_model.dart';
import 'package:bausch/models/catalog_item/webinar_item_model.dart';
import 'package:bausch/widgets/discount_info.dart';
import 'package:flutter/material.dart';

class CatalogItemModel {
  final int id;

  //* Название товара
  final String name;

  //* Текст для infoSection
  final String previewText;

  //* Текст для legalInfo
  final String detailText;

  //* Ссылка на картинку
  final String? picture;

  //* цена товара
  final int price;

  // //* Это для "вам может быть интересно"
  final String? type;

  //* Для "вам может быть интересно"
  final bool? isSection;

  String get priceToString => HelpFunctions.partitionNumber(price);
  //  HelpFunctions.partitionNumber(price);

  Widget get shield {
    if (this is WebinarItemModel) {
      return Image.asset(
        'assets/play-video.png',
        height: 28,
      );
    } else if (this is PromoItemModel) {
      return const DiscountInfo(text: '–500 ₽');
    } else {
      return Container();
    }
  }

  CatalogItemModel({
    required this.id,
    required this.name,
    required this.previewText,
    required this.detailText,
    required this.picture,
    required this.price,
    this.type,
    this.isSection,
  });

  factory CatalogItemModel.fromMap(Map<String, dynamic> map) {
    if (map['id'] == null) {
      throw ResponseParseException('Не передан идентификатор');
    }

    try {
      return CatalogItemModel(
        id: map['id'] as int,
        name: map['name'] as String,
        previewText: map['preview_text'] as String,
        detailText: map['detail_text'] as String,
        picture: map['picture'] as String,
        price: map['price'] as int,
      );
    } catch (e) {
      throw ResponseParseException('CatalogItemModel: $e');
    }
  }

  factory CatalogItemModel.mayBeInterestingItemFromJson(
    Map<String, dynamic> json,
  ) {
    return CatalogItemModel(
      id: json['id'] as int,
      name: json['name'] as String,
      previewText: '',
      detailText: '',
      picture: json['picture'] as String,
      price: json['price'] as int,
      type: json['type'] as String,
      isSection:  json['is_section'] as bool,
    );
  }
  factory CatalogItemModel.itemByTypeFromJson(
    Map<String, dynamic> json,
    String type,
  ) {
    switch (type) {
      case 'promo_code_video':
        return WebinarItemModel.fromMap(json);
      case 'offline':
      case 'onlineShop':
        return PromoItemModel.fromMap(json);
      case 'free_product':
        return ProductItemModel.fromMap(json);
      case 'promo_code_immediately':
        return PartnersItemModel.fromMap(json);
      case 'online_consultation':
        return ConsultationItemModel.fromMap(json);
      default:
        return CatalogItemModel.fromMap(json);
    }
  }
}
