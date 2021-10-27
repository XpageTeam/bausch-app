import 'package:bausch/models/mappable_object.dart';
import 'package:bausch/models/sheets/base_catalog_sheet_model.dart';

class CatalogSheetModel extends BaseCatalogSheetModel
    implements MappableInterface<CatalogSheetModel> {
  CatalogSheetModel({
    required int id,
    required String name,
    required String type,
    required String icon,
    required int count,
  }) : super(
          id: id,
          name: name,
          type: type,
          icon: icon,
          count: count,
        );

  factory CatalogSheetModel.fromMap(Map<String, dynamic> map) {
    return CatalogSheetModel(
      id: map['id'] as int,
      name: map['name'] as String,
      type: map['type'] as String,
      icon: (map['icon'] ??
              'https://baush-app.xpager.ru/upload/uf/646/8b6gclwm3bl9vvztnjas4wp1m2tln9i6.svg')
          as String,
      count: map['count'] as int,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    throw UnimplementedError();
  }
}
