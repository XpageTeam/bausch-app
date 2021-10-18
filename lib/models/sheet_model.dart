import 'package:bausch/models/catalog_item_model.dart';
import 'package:bausch/models/mappable_object.dart';
import 'package:bausch/static/static_data.dart';

class SheetModel implements MappableInterface<SheetModel> {
  final String title;
  final String? img;
  final List<CatalogItemModel> models;
  final SheetType type;

  SheetModel({
    required this.title,
    required this.models,
    required this.type,
    this.img,
  });

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    throw UnimplementedError();
  }
}
