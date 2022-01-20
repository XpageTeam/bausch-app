import 'dart:convert';

import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:flutter/foundation.dart';

@immutable
class AuthResponseModel {
  final int id;
  final bool isEmailConfirmed;
  final bool isMobilePhoneConfirmed;

  const AuthResponseModel({
    required this.id,
    this.isEmailConfirmed = false,
    this.isMobilePhoneConfirmed = false,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    try {
      return AuthResponseModel(
        id: json['id'] as int,
        isEmailConfirmed: json['isEmailConfirmed'] as bool,
        isMobilePhoneConfirmed: json['isMobilePhoneConfirmed'] as bool,
      );
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      throw ResponseParseException(e.toString());
    }
  }

  @override
  String toString() {
    return 'AuhtResponseModel(id: $id, isEmailConfirmed: $isEmailConfirmed, isMobilePhoneConfirmed: $isMobilePhoneConfirmed)';
  }

  String toJson() => json.encode({
        'id': id,
        'isEmailConfirmed': isEmailConfirmed,
        'isMobilePhoneConfirmed': isMobilePhoneConfirmed,
      });
}
