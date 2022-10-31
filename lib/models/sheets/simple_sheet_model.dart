import 'package:bausch/models/sheets/base_catalog_sheet_model.dart';

class SimpleSheetModel extends BaseCatalogSheetModel {
  SimpleSheetModel({
    required String name,
    required String type,
  }) : super(
          name: name,
          type: type,
          id: 1,
          discount: null,
        );
}
