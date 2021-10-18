import 'package:bausch/models/mappable_object.dart';

class CatalogItemModel implements MappableInterface<CatalogItemModel> {
  final String? img;
  final String name;
  final String price;

  CatalogItemModel({
    required this.name,
    required this.price,
    this.img,
  });

  @override
  Map<String, dynamic> toMap() {
    throw UnimplementedError();
  }
}
