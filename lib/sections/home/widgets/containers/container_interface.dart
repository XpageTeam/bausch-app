import 'package:bausch/models/sheets/base_catalog_sheet_model.dart';

abstract class ContainerInterface {
  final BaseCatalogSheetModel model;

  ContainerInterface({
    required this.model,
  });
}
