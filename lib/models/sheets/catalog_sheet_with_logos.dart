import 'package:bausch/models/mappable_object.dart';
import 'package:bausch/models/sheets/base_catalog_sheet_model.dart';

class CatalogSheetWithLogosModel extends BaseCatalogSheetModel
    implements MappableInterface<CatalogSheetWithLogosModel> {
  final List<String> logos;

  CatalogSheetWithLogosModel({
    required int id,
    required String name,
    required String type,
    required String icon,
    required int count,
    required this.logos,
  }) : super(
          id: id,
          name: name,
          type: type,
          icon: icon,
          count: count,
        );

  factory CatalogSheetWithLogosModel.fromMap(Map<String, dynamic> map) {
    return CatalogSheetWithLogosModel(
      id: map['id'] as int,
      name: map['name'] as String,
      type: map['type'] as String,
      icon: (map['icon'] ??
              'https://baush-app.xpager.ru/upload/uf/646/8b6gclwm3bl9vvztnjas4wp1m2tln9i6.svg')
          as String,
      count: map['count'] as int,
      logos: (map['logos'] as List<dynamic>)
          .map((dynamic logo) => logo as String)
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    throw UnimplementedError();
  }
}
