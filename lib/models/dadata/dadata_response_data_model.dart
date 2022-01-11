class DadataResponseDataModel {
  final String street;
  final String house;
  final String? block;
  final String? city;
  final String? settlement;
  //final String streetType;

  DadataResponseDataModel({
    required this.street,
    required this.house,
    this.city,
    this.settlement,
    this.block,
    //required this.streetType,
  });
  factory DadataResponseDataModel.fromMap(Map<String, dynamic> map) {
    return DadataResponseDataModel(
      street: (map['street_with_type'] ?? '') as String,
      house: (map['house'] ?? '') as String,
      block: map['block'] as String?,
      city: map['city'] as String?,
      settlement: map['settlement'] as String?,
      //streetType: (map['street_type'] ?? '') as String,
    );
  }
}
