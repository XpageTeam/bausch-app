import 'package:bausch/models/mappable_object.dart';
import 'package:bausch/models/sheets/base_catalog_sheet_model.dart';

class CatalogSheetWithoutLogosModel extends BaseCatalogSheetModel
    implements MappableInterface<CatalogSheetWithoutLogosModel> {
  CatalogSheetWithoutLogosModel({
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

  factory CatalogSheetWithoutLogosModel.fromMap(Map<String, dynamic> map) {
    return CatalogSheetWithoutLogosModel(
      id: map['id'] as int,
      name: map['name'] as String,
      type: map['type'] as String,
      icon: map['icon'] as String,
      count: map['count'] as int,
    );
  }
  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    throw UnimplementedError();
  }
}
