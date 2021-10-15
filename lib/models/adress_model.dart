import 'package:bausch/models/mappable_object.dart';

class AdressModel implements MappableInterface<AdressModel> {
  final String street;

  //* Номер квартиры
  final int? office;

  final int? floor;

  //* Номер подъезда
  final int? lobby;

  AdressModel({
    required this.street,
    this.office,
    this.floor,
    this.lobby,
  });

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    throw UnimplementedError();
  }
}
