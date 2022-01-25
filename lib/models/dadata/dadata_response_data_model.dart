// ignore_for_file: avoid_catches_without_on_clauses

import 'package:bausch/exceptions/response_parse_exception.dart';

class DadataResponseDataModel {
  final String street;
  final String house;
  final String? block;
  final String? city;
  final String? region;
  final String? settlement;
  final String? postalCode;
  //final String streetType;

  DadataResponseDataModel({
    required this.street,
    required this.house,
    this.city,
    this.region,
    this.settlement,
    this.block,
    this.postalCode,
    //required this.streetType,
  });
  factory DadataResponseDataModel.fromMap(Map<String, dynamic> map) {
    try {
      return DadataResponseDataModel(
        street: (map['street_with_type'] ?? '') as String,
        house: (map['house'] ?? '') as String,
        block: map['block'] as String?,
        region: map['region_with_type'] as String?,
        city: map['city'] as String?,
        settlement: map['settlement'] as String?,
        postalCode: map['postal_code'] as String?,
        //streetType: (map['street_type'] ?? '') as String,
      );
    } catch (e) {
      throw ResponseParseException('DadataResponseDataModel: $e');
    }
  }
}
