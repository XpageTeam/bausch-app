abstract class BaseCatalogSheetModel {
  final int id;

  //* Название раздела
  final String name;

  //* Тип страницы
  final String type;

  //* Ссылка на иконку
  final String? icon;

  //* Ссылка на вторую иконку
  final String? secondIcon;

  //* Количество элементов внутри
  final int? count;

  BaseCatalogSheetModel({
    required this.id,
    required this.name,
    required this.type,
    this.icon,
    this.secondIcon,
    this.count,
  });
}
