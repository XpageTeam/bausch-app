import 'package:bausch/exceptions/response_parse_exception.dart';

class PrimaryData {
  final String title;
  final String description;
  final List<Product> products;
  final List<String> importantToKnow;
  final List<String> whatDoYouUse;

  PrimaryData({
    required this.title,
    required this.description,
    required this.products,
    required this.importantToKnow,
    required this.whatDoYouUse,
  });

  factory PrimaryData.fromJson(Map<String, dynamic> map) {
    if (map['title'] == null) {
      throw ResponseParseException(
        'Не передано название программы подбора',
      );
    }
    if (map['description'] == null) {
      throw ResponseParseException(
        'Не передано описание программы подбора',
      );
    }
    if (map['products'] == null) {
      throw ResponseParseException(
        'Не передан список товаров программы подбора',
      );
    }
    if (map['importantToKnow'] == null) {
      throw ResponseParseException(
        'Не передана важная информация программы подбора',
      );
    }
    if (map['whatDoYouUse'] == null) {
      throw ResponseParseException(
        'Не передан список используемых оптических приборов программы подбора',
      );
    }

    return PrimaryData(
      title: map['title'] as String,
      description: map['description'] as String,
      products: (map['products'] as List<dynamic>)
          .map((dynamic e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
      importantToKnow: (map['importantToKnow'] as List<dynamic>)
          .map((dynamic e) => e as String)
          .toList(),
      whatDoYouUse: (map['whatDoYouUse'] as List<dynamic>)
          .map((dynamic e) => e as String)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'title': title,
        'description': description,
        'products': List<dynamic>.from(
          products.map<dynamic>((x) => x.toJson()),
        ),
        'importantToKnow': List<String>.from(
          importantToKnow.map<String>((x) => x),
        ),
        'whatDoYouUse': List<String>.from(
          whatDoYouUse.map<String>((x) => x),
        ),
      };
}

class Product {
  final String name;
  final String picture;
  final num price;

  Product({
    required this.name,
    required this.picture,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> map) {
    if (map['name'] == null) {
      throw ResponseParseException(
        'Не передано название товара из программы подбора',
      );
    }
    if (map['picture'] == null) {
      throw ResponseParseException(
        'Не передана картинка товара из программы подбора',
      );
    }
    if (map['price'] == null) {
      throw ResponseParseException(
        'Не передана цена товара из программы подбора',
      );
    }

    return Product(
      name: map['name'] as String,
      picture: map['picture'] as String,
      price: map['price'] as num,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'picture': picture,
        'price': price,
      };
}
