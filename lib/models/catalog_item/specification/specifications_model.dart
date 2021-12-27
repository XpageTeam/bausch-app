import 'package:bausch/models/catalog_item/specification/specification_model.dart';
import 'package:bausch/models/mappable_object.dart';

class SpecificationsModel implements MappableInterface<SpecificationsModel> {
  final List<String>? diopters;
  final List<String>? cylinders;
  final List<String>? axis;
  final List<String>? addidations;
  final List<String>? color;

  SpecificationsModel({
    this.diopters,
    this.cylinders,
    this.axis,
    this.addidations,
    this.color,
  });

  factory SpecificationsModel.fromMap(Map<String, dynamic> map) {
    return SpecificationsModel(
      diopters: map['diopters'] != null
          ? (map['diopters'] as List<dynamic>)
              .map((dynamic e) => e as String)
              .toList()
          : null,
      cylinders: map['cylinders'] != null
          ? (map['cylinders'] as List<dynamic>)
              .map((dynamic e) => e as String)
              .toList()
          : null,
      axis: map['axis'] != null
          ? (map['axis'] as List<dynamic>)
              .map((dynamic e) => e as String)
              .toList()
          : null,
      addidations: map['addidations'] != null
          ? (map['addidations'] as List<dynamic>)
              .map((dynamic e) => e as String)
              .toList()
          : null,
      color: map['color'] != null
          ? (map['color'] as List<dynamic>)
              .map((dynamic e) => e as String)
              .toList()
          : null,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    throw UnimplementedError();
  }
}
