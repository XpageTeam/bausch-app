import 'package:bausch/models/mappable_object.dart';
import 'package:bausch/static/static_data.dart';

class SimpleSheetModel implements MappableInterface<SimpleSheetModel> {
  final String title;
  final SimpleSheetType type;

  SimpleSheetModel({required this.title, required this.type});

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    throw UnimplementedError();
  }
}
