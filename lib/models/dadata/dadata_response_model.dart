import 'package:bausch/models/dadata/dadata_response_data_model.dart';

class DadataResponseModel {
  final String value;
  final String unrestrictedValue;
  final DadataResponseDataModel data;

  DadataResponseModel({
    required this.value,
    required this.unrestrictedValue,
    required this.data,
  });

  factory DadataResponseModel.fromMap(Map<String, dynamic> map) {
    return DadataResponseModel(
      value: (map['value'] ?? '') as String,
      unrestrictedValue: (map['unrestrictedValue'] ?? '') as String,
      data:
          DadataResponseDataModel.fromMap(map['data'] as Map<String, dynamic>),
    );
  }
}
