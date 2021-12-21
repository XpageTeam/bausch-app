import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/models/mappable_object.dart';

class AdressModel implements MappableInterface<AdressModel> {
  final int? id;

  //* Улица
  final String street;

  //* Номер дома
  final String? house;

  //* Номер квартиры
  final int? flat;

  //* Номер подъезда
  final int? entry;

  //* этаж
  final int? floor;

  final String? city;

  AdressModel({
    required this.street,
    this.id,
    this.house,
    this.flat,
    this.entry,
    this.floor,
    this.city,
  });

  factory AdressModel.fromMap(Map<String, dynamic> map) {
    if (map['id'] == null) {
      ResponseParseException('Не передан id');
    }

    if (map['street'] == null) {
      ResponseParseException('Не передано название улицы');
    }

    if (map['house'] == null) {
      ResponseParseException('Не передан номер дома');
    }

    if (map['flat'] == null) {
      ResponseParseException('Не передан номер квартиры');
    }

    return AdressModel(
      id: map['id'] as int,
      street: map['street'] as String,
      house: map['house'] as String,
      flat: map['flat'] as int,
      entry: map['entry'] as int,
      floor: map['floor'] as int,
      city: map['city'] as String,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'street': street,
      'house': house,
      'flat': flat,
      'entry': entry,
      'floor': floor,
    };
  }
}
