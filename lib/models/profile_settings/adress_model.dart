import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/models/mappable_object.dart';

class AdressModel implements MappableInterface<AdressModel> {
  final int? id;

  /// Улица
  final String street;

  /// Номер дома
  final String? house;

  /// Номер квартиры
  final int? flat;

  /// Номер подъезда
  final int? entry;

  /// этаж
  final int? floor;

  /// регион
  final String? region;

  /// Город
  final String? city;

  /// посёлок\село
  final String? settlement;

  /// индекс
  final String? zipCode;

  String get fullAddress {
    var address = '';

    if (region != null){
      address += '$region, ';
    }

    address += cityAndSettlement;

    return address;
  }

  String get cityAndSettlement {
    var address = '';

    if (city != null){
      address += '$city${settlement != null ? ', ' : ''}';
    }

    if (settlement != null){
      address += settlement!;
    }

    return address;
  }

  AdressModel({
    required this.street,
    this.id,
    this.house,
    this.flat,
    this.entry,
    this.floor,
    this.region,
    this.city,
    this.settlement,
    this.zipCode,
  });

  factory AdressModel.fromMap(Map<String, dynamic> map) {
    if (map['id'] == null) {
      ResponseParseException('AdressModel: Не передан id');
    }

    if (map['street'] == null) {
      ResponseParseException('AdressModel: Не передано название улицы');
    }

    if (map['house'] == null) {
      ResponseParseException('AdressModel: Не передан номер дома');
    }

    try {
      return AdressModel(
        id: map['id'] as int,
        street: map['street'] as String,
        house: map['house'] as String,
        flat: map['flat'] as int?,
        entry: map['entry'] as int?,
        floor: map['floor'] as int?,
        region: map['region'] as String?,
        city: map['city'] as String?,
        settlement: map['settlement'] as String?,
        zipCode: (map['zip'] as int? ?? '').toString(),
      );
    // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      throw ResponseParseException('AdressModel: $e');
    }
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'street': street,
      'house': house,
      'flat': flat,
      'entry': entry,
      'floor': floor,
      'region': region,
      'settlement': settlement,
      'city': city,
      'zip': zipCode,
    };
  }
}
