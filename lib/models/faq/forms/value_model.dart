import 'package:bausch/models/mappable_object.dart';

class ValueModel implements MappableInterface<ValueModel> {
  final int id;
  final String name;

  ValueModel({
    required this.id,
    required this.name,
  });

  factory ValueModel.fromMap(Map<String, dynamic> map) {
    return ValueModel(
      id: map['id'] as int,
      name: map['name'] as String,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    // TODO(all): implement toMap
    throw UnimplementedError();
  }
}
