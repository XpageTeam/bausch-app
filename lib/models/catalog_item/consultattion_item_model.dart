import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/models/catalog_item/catalog_item_model.dart';
import 'package:bausch/models/mappable_object.dart';

class ConsultationItemModel extends CatalogItemModel
    implements MappableInterface<ConsultationItemModel> {
  //* Продолжительность консультации в минутах
  final int length;

  ConsultationItemModel({
    required int id,
    required String name,
    required String previewText,
    required String detailText,
    required String? picture,
    required int price,
    required this.length,
  }) : super(
          id: id,
          name: name,
          previewText: previewText,
          detailText: detailText,
          picture: picture,
          price: price,
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

    return ConsultationItemModel(
      id: map['id'] as int,
      name: map['name'] as String,
      previewText: map['preview_text'] as String,
      detailText: map['detail_text'] as String,
      picture: map['picture'] as String?,
      price: (map['price'] ?? 150) as int,
      length: map['length'] as int,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    throw UnimplementedError();
  }
}
