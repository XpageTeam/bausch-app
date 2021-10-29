import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/models/catalog_item/catalog_item_model.dart';
import 'package:bausch/models/mappable_object.dart';

class ProductItemModel extends CatalogItemModel
    implements MappableInterface<ProductItemModel> {
  ProductItemModel({
    required int id,
    required String name,
    required String previewText,
    required String detailText,
    required String picture,
    required int price,
  }) : super(
          id: id,
          name: name,
          previewText: previewText,
          detailText: detailText,
          picture: picture,
          price: price,
        );

  factory ProductItemModel.fromMap(Map<String, dynamic> map) {
    if (map['id'] == null) {
      throw ResponseParseExeption('Не передан идентификатор');
    }

    // if (map['name'] == null) {
    //   throw ResponseParseExeption('Не передано название товара');
    // }

    if (map['preview_text'] == null) {
      throw ResponseParseExeption('Не передан превью текст');
    }

    if (map['detail_text'] == null) {
      throw ResponseParseExeption('Не передан детаил текст');
    }
    if (map['price'] == null) {
      throw ResponseParseExeption('Не передана цена товара');
    }

    return ProductItemModel(
      id: map['id'] as int,
      name: (map['name'] ?? 'name') as String,
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
