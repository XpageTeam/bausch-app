import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/models/mappable_object.dart';

class CatalogItemModel implements MappableInterface<CatalogItemModel> {
  final int id;

  //* Название товара
  final String name;

  //* Текст для infoSection
  final String previewText;

  //* Текст для legalInfo
  final String detailText;

  //* Ссылка на картинку
  final String picture;

  //* цена товара
  final int price;

  CatalogItemModel({
    required this.id,
    required this.name,
    required this.previewText,
    required this.detailText,
    required this.picture,
    required this.price,
  });

  factory CatalogItemModel.fromMap(Map<String, dynamic> map) {
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

    return CatalogItemModel(
      id: map['id'] as int,
      name: map['name'] as String,
      previewText: map['preview_text'] as String,
      detailText: map['detail_text'] as String,
      picture:
          'https://ryady.ru/upload/resize_cache/iblock/6c2/600_600_1/000000000000060033_0.jpg',
      price: (map['price'] ?? 150) as int,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'previewText': previewText,
      'detailtext': detailText,
      'picture': picture,
      'price': price,
    };
  }
}
