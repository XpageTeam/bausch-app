import 'package:bausch/models/catalog_item_model.dart';
import 'package:bausch/models/mappable_object.dart';

class SheetModel implements MappableInterface<SheetModel> {
  final String title;
  final String? img;
  final List<CatalogItemModel> models;

  SheetModel({required this.title, required this.models, this.img});

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    throw UnimplementedError();
  }
}
