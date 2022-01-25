// ignore_for_file: avoid_catches_without_on_clauses

import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/models/mappable_object.dart';

class LensParametersModel implements MappableInterface<LensParametersModel> {
  final num cylinder;
  final num diopter;
  final num axis;
  final num addict;

  LensParametersModel({
    required this.cylinder,
    required this.diopter,
    required this.axis,
    required this.addict,
  });

  factory LensParametersModel.fromMap(Map<String, dynamic> map) {
    try {
      return LensParametersModel(
        cylinder: map['cyl'] as num,
        diopter: map['diopter'] as num,
        axis: map['axis'] as num,
        addict: map['addict'] as num,
      );
    } catch (e) {
      throw ResponseParseException('LensParametersModel: $e');
    }
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'diopter': diopter,
      'axis': axis,
      'addict': addict,
      'cyl': cylinder,
    };
  }
}
