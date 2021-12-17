import 'package:bausch/help/help_functions.dart';

class CatalogItemModel {
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

  String get priceToString => price.formatString; // Это геттер из extension
  //  HelpFunctions.partitionNumber(price);

  CatalogItemModel({
    required this.id,
    required this.name,
    required this.previewText,
    required this.detailText,
    required this.picture,
    required this.price,
  });
}
