// ignore_for_file: avoid_annotating_with_dynamic

import 'package:bausch/models/mappable_object.dart';
import 'package:bausch/models/sheets/base_catalog_sheet_model.dart';

class CatalogSheetWithLogosModel extends BaseCatalogSheetModel
    implements MappableInterface<CatalogSheetWithLogosModel> {
  final List<String>? logos;

  CatalogSheetWithLogosModel({
    required int id,
    required String name,
    required String type,
    required String icon,
    required int count,
    this.logos,
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
              'https://baush-app.xpager.ru/upload/uf/aa5/heterm9de8wkk1pvr37o5rqxrymh66cd.jpg')
          as String,
      count: map['count'] as int,
      logos: map['logos'] != null
          ? (map['logos'] as List<dynamic>)
              .map((dynamic logo) => logo as String)
              .toList()
          : null,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    // TODO(all): implement toMap
    throw UnimplementedError();
  }
}
