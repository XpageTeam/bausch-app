// ignore_for_file: avoid_catches_without_on_clauses

import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/models/sheets/base_catalog_sheet_model.dart';

class CatalogSheetModel extends BaseCatalogSheetModel {
  CatalogSheetModel({
    required int id,
    required String name,
    required String type,
    required int count,
    String? icon,
    String? secondIcon,
    String? discount,
  }) : super(
          id: id,
          name: name,
          type: type,
          icon: icon,
          secondIcon: secondIcon,
          count: count,
          discount: discount,
        );

  factory CatalogSheetModel.fromMap(Map<String, dynamic> map) {
    try {
      return CatalogSheetModel(
        id: map['id'] as int,
        name: map['name'] as String,
        type: map['type'] as String,
        icon: map['icon'] as String?,
        secondIcon: map['secondIcon'] as String?,
        count: map['count'] as int,
        discount: map['sale'] as String?,
      );
    } catch (e) {
      throw ResponseParseException('CatalogSheetModel: $e');
    }
  }
}
