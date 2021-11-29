// ignore_for_file: unnecessary_cast

import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:flutter/material.dart';

/// Модель города, предоставляемая сервисом dadata
class DadataCity {
  final String kladrID;
  final String fiasID;
  final String postalCode;
  final String fiasLevel;

  final String timezone;
  final String cityType;
  final String name;
  final String regionType;
  final String regionName;
  final String address;

  const DadataCity({
    required this.kladrID,
    required this.fiasID,
    required this.postalCode,
    required this.fiasLevel,
    required this.timezone,
    required this.cityType,
    required this.name,
    required this.regionType,
    required this.regionName,
    required this.address,
  });

  factory DadataCity.fromCSV(List<dynamic> csv) {
    try {
      var cityName = csv[9].toString() != '' ? csv[9].toString() : csv[5].toString();

      if (csv[8].toString() == ''){
        if (csv[6].toString().toLowerCase() == 'г'){
          cityName = csv[7].toString();
        } else {
          cityName = csv[5].toString();
        }
      }

      return DadataCity(
        kladrID: csv[12].toString(),
        fiasID: csv[13].toString(),
        postalCode: csv[1].toString(),
        fiasLevel: csv[14].toString(),
        timezone: csv[19].toString(),
        cityType: csv[8].toString(),
        name: cityName,
        regionType: csv[4].toString(),
        regionName: csv[5].toString(),
        address: csv[0].toString(),
      );
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      throw ResponseParseException(e.toString());
    }
  }

  factory DadataCity.fromJson(Map<String, dynamic> json) {
    try {
      return DadataCity(
        kladrID: json['kladr_id'] as String,
        fiasID: json['fias_id'] as String,
        postalCode: json['postal_code'] as String,
        fiasLevel: json['fias_level'] as String,
        timezone: json['timezone'] as String,
        cityType: json['city_type'] as String,
        name: json['city'] as String,
        regionType: json['region_type'] as String,
        regionName: json['region'] as String,
        address: json['address'] as String,
      );
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      throw ResponseParseException(e.toString());
    }
  }

  @override
  String toString() {
    return 'DadataCity: ${toJson()}';
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'kladr_id': kladrID,
      'fias_id': fiasID,
      'postal_code': postalCode,
      'fias_level': fiasLevel,
      'timezone': timezone,
      'city_type': cityType,
      'region_type': regionType,
      'region': regionName,
      'address': address,
      'name': name,
    };
  }
}
