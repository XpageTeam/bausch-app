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

    if (region != null && region!.isNotEmpty) {
      address += '$region, ';
    }

    address += cityAndSettlement;

    return address;
  }

  String get cityAndSettlement {
    var address = '';

    if (city != null && city!.isNotEmpty) {
      address +=
          '$city${settlement != null && settlement!.isNotEmpty ? ', ' : ''}';
    }

    if (settlement != null && settlement != '') {
      address += settlement!;
    }

    return address;
  }

  String? get subAddress {
    final sb = StringBuffer();
    var hasBefore = false;

    hasBefore = _write(
      value: flat,
      sb: sb,
      predicate: (value) => value != null && value >= 0,
      hasBefore: hasBefore,
      valueBuilder: (value) => 'кв. $value',
    );

    hasBefore = _write(
      value: entry,
      sb: sb,
      predicate: (value) => value != null && value >= 0,
      hasBefore: hasBefore,
      valueBuilder: (value) => 'подъезд $value',
    );

    hasBefore = _write(
      value: floor,
      sb: sb,
      predicate: (value) => value != null,
      hasBefore: hasBefore,
      valueBuilder: (value) => 'этаж $value',
    );

    // if (flat != null && flat! >= 0) {
    //   sb.write('кв. $flat');
    //   hasBefore = true;
    // } else {
    //   hasBefore = false;
    // }

    // if (entry != null && entry! >= 0) {
    //   if (hasBefore) {
    //     sb.write(', ');
    //   }
    //   sb.write('подъезд $entry');
    //   hasBefore = true;
    // } else {
    //   hasBefore = false;
    // }

    // if (floor != null) {
    //   if (hasBefore) {
    //     sb.write(', ');
    //   }
    //   sb.write('этаж $floor');
    //   hasBefore = true;
    // } else {
    //   hasBefore = false;
    // }
    final result = sb.toString();
    return result.isEmpty ? null : result;
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

    bool _write({
    required int? value,
    required StringBuffer sb,
    required bool Function(int? value) predicate,
    required bool hasBefore,
    required String Function(int value) valueBuilder,
  }) {
    if (predicate(value)) {
      if (hasBefore) {
        sb.write(', ');
      }
      sb.write(valueBuilder(value!));
      return true;
    } else {
      return false;
    }
  }
}
