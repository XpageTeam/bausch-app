import 'package:bausch/models/mappable_object.dart';
import 'package:bausch/widgets/catalog_item/catalog_item_widget.dart';

class CatalogItemModel implements MappableInterface<CatalogItemModel> {
  final String? img;
  final String name;
  final String price;
  final String? address;
  final String? deliveryInfo;
  final ItemType? type;

  CatalogItemModel({
    required this.name,
    required this.price,
    this.type = ItemType.product,
    this.address,
    this.img,
    this.deliveryInfo,
  });

  @override
  Map<String, dynamic> toMap() {
    throw UnimplementedError();
  }
}
