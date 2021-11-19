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

  CatalogItemModel({
    required this.id,
    required this.name,
    this.previewText = 'test',
    this.detailText = 'test',
    required this.picture,
    required this.price,
  });
}
