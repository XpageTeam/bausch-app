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
    return CodeResponseModel(
      confirmed: json['confirmed'] as bool,
      xApiToken: json['x-api-token'] as String,
    );
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
