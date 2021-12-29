import 'package:bausch/models/mappable_object.dart';
import 'package:bausch/models/sheets/base_catalog_sheet_model.dart';

class SimpleSheetModel extends BaseCatalogSheetModel
    implements MappableInterface<SimpleSheetModel> {
  SimpleSheetModel({
    required String name,
    required String type,
  }) : super(
          name: name,
          type: type,
          id: 1,
        );

  @override
  Map<String, dynamic> toMap() {
    // TODO(all): implement toMap
    throw UnimplementedError();
  }
}
