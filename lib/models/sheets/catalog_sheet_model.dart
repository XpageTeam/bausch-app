import 'package:bausch/models/mappable_object.dart';

class CatalogSheetModel implements MappableInterface<CatalogSheetModel> {
  final int id;

  //* Название раздела
  final String name;

  //* Тип страницы
  final String type;

  //* Что-то
  final int sort;

  //* Ссылка на иконку
  final String icon;

  //* Количество элементов внутри
  final int count;

  //* Ссылки на логотипы
  final List<String>? logos;

  CatalogSheetModel({
    required this.id,
    required this.name,
    required this.type,
    required this.sort,
    required this.icon,
    required this.count,
    this.logos,
  });

  factory CatalogSheetModel.fromMap(Map<String, dynamic> map) {
    return CatalogSheetModel(
      id: map['id'] as int,
      name: map['name'] as String,
      type: map['type'] as String,
      sort: map['sort'] as int,
      icon: map['icon'] as String,
      count: map['count'] as int,
      logos: map['type'] == 'shop'
          ? (map['logos'] as List<dynamic>)
              .map((dynamic e) => e as String)
              .toList()
          : null,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    throw UnimplementedError();
  }
}
