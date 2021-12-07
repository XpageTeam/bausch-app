import 'package:bausch/models/mappable_object.dart';

class LensParametersModel implements MappableInterface<LensParametersModel> {
  final int cylinder;
  final int diopter;
  final int axis;
  final int addict;

  LensParametersModel({
    required this.cylinder,
    required this.diopter,
    required this.axis,
    required this.addict,
  });

  factory LensParametersModel.fromMap(Map<String, dynamic> map) {
    return LensParametersModel(
      cylinder: map['cyl'] as int,
      diopter: map['diopter'] as int,
      axis: map['axis'] as int,
      addict: map['addict'] as int,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'diopter': diopter,
      'axis': axis,
      'addict': addict,
      'cylinder': cylinder,
    };
  }
}
