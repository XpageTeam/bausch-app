abstract class BaseCatalogSheetModel {
  final int id;

  //* Название раздела
  final String name;

  //* Тип страницы
  final String type;

  //* Ссылка на иконку
  final String? icon;

  //* Количество элементов внутри
  final int? count;

  BaseCatalogSheetModel({
    required this.id,
    required this.name,
    required this.type,
    this.icon,
    this.count,
  });
}
