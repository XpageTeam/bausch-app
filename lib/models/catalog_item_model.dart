import 'package:bausch/models/mappable_object.dart';

class CatalogItemModel implements MappableInterface<CatalogItemModel> {
  final String? img;
  final String name;
  final String price;
  final String? discount;

  CatalogItemModel({
    required this.name,
    required this.price,
    this.discount,
    this.img,
  });

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    throw UnimplementedError();
  }
}
