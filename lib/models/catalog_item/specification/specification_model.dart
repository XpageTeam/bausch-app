import 'package:bausch/models/mappable_object.dart';

class SpecificationModel implements MappableInterface<SpecificationModel> {
  final String title;
  final String value;

  SpecificationModel({
    required this.title,
    required this.value,
  });

  factory SpecificationModel.fromMap(Map<String, dynamic> map) {
    return SpecificationModel(
      title: map['title'] as String,
      value: map['value'] as String,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    throw UnimplementedError();
  }
}
