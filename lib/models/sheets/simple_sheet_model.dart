import 'package:bausch/models/mappable_object.dart';
import 'package:bausch/models/sheets/base_catalog_sheet_model.dart';

class SimpleSheetModel extends BaseCatalogSheetModel
    implements MappableInterface<SimpleSheetModel> {
  @override
  final String name;
  @override
  final String type;

  SimpleSheetModel({
    required this.name,
    required this.type,
  }) : super(
          name: name,
          type: type,
          id: 1,
        );

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    throw UnimplementedError();
  }
}
