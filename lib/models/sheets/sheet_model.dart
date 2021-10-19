import 'package:bausch/models/mappable_object.dart';
import 'package:bausch/static/static_data.dart';

class SheetModel implements MappableInterface<SheetModel> {
  final String title;
  final String img;
  final SheetType type;

  SheetModel({required this.title, required this.img, required this.type});

  @override
  Map<String, dynamic> toMap() {
    throw UnimplementedError();
  }
}
