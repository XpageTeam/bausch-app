import 'package:bausch/models/catalog_item/specification/specification_model.dart';
import 'package:bausch/models/mappable_object.dart';

class SpecificationsModel implements MappableInterface<SpecificationsModel> {
  final List<SpecificationModel>? diopters;
  final List<SpecificationModel>? cylinders;
  final List<SpecificationModel>? axis;
  final List<SpecificationModel>? addidations;

  SpecificationsModel({
    this.diopters,
    this.cylinders,
    this.axis,
    this.addidations,
  });

  factory SpecificationsModel.fromMap(Map<String, dynamic> map) {
    return SpecificationsModel(
      diopters: map['diopters'] != null
          ? (map['diopters'] as List<dynamic>)
              .map((dynamic e) =>
                  SpecificationModel.fromMap(e as Map<String, dynamic>))
              .toList()
          : null,
      cylinders: map['cylinders'] != null
          ? (map['cylinders'] as List<dynamic>)
              .map((dynamic e) =>
                  SpecificationModel.fromMap(e as Map<String, dynamic>))
              .toList()
          : null,
      axis: map['axis'] != null
          ? (map['axis'] as List<dynamic>)
              .map((dynamic e) =>
                  SpecificationModel.fromMap(e as Map<String, dynamic>))
              .toList()
          : null,
      addidations: map['addidations'] != null
          ? (map['addidations'] as List<dynamic>)
              .map((dynamic e) =>
                  SpecificationModel.fromMap(e as Map<String, dynamic>))
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
