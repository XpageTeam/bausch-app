// ignore_for_file: avoid_catches_without_on_clauses

import 'package:bausch/exceptions/response_parse_exception.dart';
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
    try {
      return DadataResponseModel(
        value: (map['value'] ?? '') as String,
        unrestrictedValue: (map['unrestrictedValue'] ?? '') as String,
        data: DadataResponseDataModel.fromMap(
          map['data'] as Map<String, dynamic>,
        ),
      );
    } catch (e) {
      throw ResponseParseException('DadataResponseModel: $e');
    }
  }
}
