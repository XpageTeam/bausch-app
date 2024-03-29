// ignore_for_file: avoid_annotating_with_dynamic, avoid_catches_without_on_clauses

import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/models/catalog_item/catalog_item_model.dart';

class WebinarItemModel extends CatalogItemModel {
  //* Идентификатор ролика
  final List<String> videoIds;
  final bool availability;
  final bool? isBought;

  bool get canWatch => isBought != null && isBought!;

  WebinarItemModel({
    required int id,
    required String name,
    required String previewText,
    required String detailText,
    required String picture,
    required int price,
    required this.videoIds,
    required this.availability,
    this.isBought,
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

  factory WebinarItemModel.fromMap(Map<String, dynamic> map) {
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
      return WebinarItemModel(
        id: map['id'] as int,
        name: map['name'] as String,
        previewText: map['preview_text'] as String,
        detailText: map['detail_text'] as String,
        picture: map['picture'] as String,
        price: map['price'] as int,
        videoIds: map['video_vimeo_id'] != null
            ? (map['video_vimeo_id'] as List<dynamic>)
                .map((dynamic e) => e as String)
                .toList()
            : [''],
        availability: map['availability'] as bool,
        isBought: map['isBought'] as bool?,
      );
    } catch (e) {
      throw ResponseParseException('WebinarItemModel: $e');
    }
  }
}
