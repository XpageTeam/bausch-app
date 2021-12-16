// ignore_for_file: avoid_annotating_with_dynamic

import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/models/catalog_item/catalog_item_model.dart';
import 'package:bausch/models/mappable_object.dart';

class WebinarItemModel extends CatalogItemModel
    implements MappableInterface<WebinarItemModel> {
  //* Идентификатор ролика
  final List<String> videoId;
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
    required this.videoId,
    required this.availability,
    required this.isBought,
  }) : super(
          id: id,
          name: name,
          previewText: previewText,
          detailText: detailText,
          picture: picture,
          price: price,
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

    return WebinarItemModel(
      id: map['id'] as int,
      name: map['name'] as String,
      previewText: map['preview_text'] as String,
      detailText: map['detail_text'] as String,
      picture:
          'https://icdn.lenta.ru/images/2019/12/06/10/20191206104306174/pwa_vertical_1280_4c9fd519bc66e04b4a6eb24307a025ad.jpg',
      price: (map['price'] ?? 150) as int,
      videoId: map['video_youtube_id'] != null
          ? (map['video_youtube_id'] as List<dynamic>)
              .map((dynamic e) => e as String)
              .toList()
          : [''],
      availability: map['availability'] as bool,
      isBought: map['isBought'] as bool?,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    throw UnimplementedError();
  }
}
