import 'package:bausch/models/mappable_object.dart';

class SheetModel implements MappableInterface<SheetModel> {
  final String title;
  final String? img;

  SheetModel({required this.title, this.img});

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    throw UnimplementedError();
  }
}
