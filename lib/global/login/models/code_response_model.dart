import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:flutter/foundation.dart';

@immutable
class CodeResponseModel {
  final bool confirmed;
  final String xApiToken;

  const CodeResponseModel({
    required this.confirmed,
    required this.xApiToken,
  });

  factory CodeResponseModel.fromJson(Map<String, dynamic> json) {
    try {
      return CodeResponseModel(
        confirmed: json['confirmed'] as bool,
        xApiToken: json['x-api-token'] as String,
      );
    // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      throw ResponseParseException(e.toString());
    }
  }

  @override
  String toString() {
    return 'CodeResponsezModel(confirmed: $confirmed, xApiToken: $xApiToken)';
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'confirmed': confirmed,
        'x-api-token': xApiToken,
      };
}
