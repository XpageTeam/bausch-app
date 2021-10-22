import 'package:bausch/models/mappable_object.dart';
import 'package:bausch/static/static_data.dart';

class SheetModelWithoutItems
    implements MappableInterface<SheetModelWithoutItems> {
  final String title;
  final String img;
  final SheetWithoutItemsType type;

  SheetModelWithoutItems({
    required this.title,
    required this.img,
    required this.type,
  });

  @override
  Map<String, dynamic> toMap() {
    throw UnimplementedError();
  }
}
