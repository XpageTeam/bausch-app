import 'package:bausch/models/mappable_object.dart';

class AddItemModel implements MappableInterface<AddItemModel> {
  final String title;
  final String subtitle;
  final String price;
  final String img;

  AddItemModel({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.img,
  });

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    throw UnimplementedError();
  }
}
