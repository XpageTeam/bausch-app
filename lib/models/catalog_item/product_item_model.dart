import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/models/catalog_item/catalog_item_model.dart';
import 'package:bausch/models/catalog_item/specification/specifications_model.dart';
import 'package:bausch/models/mappable_object.dart';

class ProductItemModel extends CatalogItemModel
    implements MappableInterface<ProductItemModel> {
  final SpecificationsModel? specifications;
  ProductItemModel({
    required int id,
    required String name,
    required String previewText,
    required String detailText,
    required String? picture,
    required int price,
    this.specifications,
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
      throw ResponseParseException('Не передан идентификатор');
    }

    // if (map['name'] == null) {
    //   throw ResponseParseExeption('Не передано название товара');
    // }

    if (map['preview_text'] == null) {
      throw ResponseParseException('Не передан превью текст');
    }

    if (map['detail_text'] == null) {
      throw ResponseParseException('Не передан детаил текст');
    }
    if (map['price'] == null) {
      throw ResponseParseException('Не передана цена товара');
    }

    return ProductItemModel(
      id: map['id'] as int,
      //TODO(Nikita): Попросить сделать одинаковые названия
      name: (map['name'] ?? map['title']) as String,
      previewText: map['preview_text'] as String,
      detailText: map['detail_text'] as String,
      picture: map['picture'] as String?,
      price: (map['price'] ?? 150) as int,
      specifications: map['specifications'] != null
          ? SpecificationsModel.fromMap(
              map['specifications'] as Map<String, dynamic>,
            )
          : null,
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
