import 'package:bausch/models/mappable_object.dart';

class FieldModel implements MappableInterface<FieldModel> {
  final int id;
  final String type;
  final String name;
  final List<String>? values;
  final bool? isRequired;

  FieldModel({
    required this.id,
    required this.type,
    required this.name,
    this.isRequired,
    this.values,
  });

  factory FieldModel.fromMap(Map<String, dynamic> map) {
    return FieldModel(
      id: map['id'] as int,
      type: map['type'] as String,
      name: map['name'] as String,
      isRequired: map['required'] != null ? map['required'] as bool : null,
      values: map['values'] != null
          ? (map['values'] as List<dynamic>)
              .map((dynamic e) => (e as Map<String, dynamic>)['name'] as String)
              .toList()
          : ['one', 'hwo'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    throw UnimplementedError();
  }
}
