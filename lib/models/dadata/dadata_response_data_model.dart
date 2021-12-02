import 'package:bausch/models/mappable_object.dart';

class DadataResponseDataModel
    implements MappableInterface<DadataResponseDataModel> {
  final String street;
  final String house;
  final String streetType;

  DadataResponseDataModel({
    required this.street,
    required this.house,
    required this.streetType,
  });
  factory DadataResponseDataModel.fromMap(Map<String, dynamic> map) {
    return DadataResponseDataModel(
      street: map['street'] as String,
      house: (map['house'] ?? '') as String,
      streetType: (map['street_type'] ?? '') as String,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    throw UnimplementedError();
  }
}
