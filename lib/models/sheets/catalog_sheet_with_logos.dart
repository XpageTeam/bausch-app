// ignore_for_file: avoid_annotating_with_dynamic, avoid_catches_without_on_clauses

import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/models/sheets/base_catalog_sheet_model.dart';

class CatalogSheetWithLogosModel extends BaseCatalogSheetModel {
  final List<String>? logos;

  CatalogSheetWithLogosModel({
    required int id,
    required String name,
    required String type,
    required String icon,
    required int count,
    String? discount,
    this.logos,
  }) : super(
          id: id,
          name: name,
          type: type,
          icon: icon,
          count: count,
          discount: discount,
        );

  factory CatalogSheetWithLogosModel.fromMap(Map<String, dynamic> map) {
    try {
      return CatalogSheetWithLogosModel(
        id: map['id'] as int,
        name: map['name'] as String,
        type: map['type'] as String,
        icon: (map['icon'] ??
                'https://bausch.in-progress.ru/upload/uf/aa5/heterm9de8wkk1pvr37o5rqxrymh66cd.jpg')
            as String,
        count: map['count'] as int,
        logos: map['logos'] != null
            ? (map['logos'] as List<dynamic>)
                .map((dynamic logo) => logo as String)
                .toList()
            : null,
        discount: map['sale'] as String?,
      );
    } catch (e) {
      throw ResponseParseException('CatalogSheetWithLogosModel: $e');
    }
  }
}
