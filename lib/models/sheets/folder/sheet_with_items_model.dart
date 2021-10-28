import 'package:bausch/models/catalog_item/catalog_item_model.dart';
import 'package:bausch/models/mappable_object.dart';
import 'package:bausch/static/static_data.dart';

class SheetModelWithItems implements MappableInterface<SheetModelWithItems> {
  final String title;
  final String? img;
  final List<CatalogItemModel>? models;
  final SheetWithItemsType type;

  SheetModelWithItems({
    required this.title,
    required this.type,
    this.models,
    this.img,
  });

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    throw UnimplementedError();
  }
}
