import 'package:bausch/models/catalog_item/catalog_item_model.dart';
import 'package:bausch/models/sheets/base_catalog_sheet_model.dart';
import 'package:bausch/models/sheets/catalog_sheet_model.dart';
import 'package:bausch/models/sheets/catalog_sheet_with_logos.dart';
import 'package:bausch/models/sheets/catalog_sheet_without_logos_model.dart';

BaseCatalogSheetModel sheetModel(CatalogItemModel model) {
  switch (model.type) {
    case 'offline':
      return CatalogSheetWithLogosModel(
        id: model.id,
        name: model.name,
        type: model.type!,
        icon: model.picture!,
        count: 1,
      );
    //* Добавил, т.к. консультация пока что приходит
    case 'online_consultation':
      return CatalogSheetWithoutLogosModel(
        id: 0,
        name: model.name,
        type: model.type!,
        icon: model.picture!,
        count: 1,
      );

    default:
      return CatalogSheetModel(
        id: 0,
        name: model.name,
        type: model.type!,
        icon: model.picture,
        count: 1,
      );
  }
}
