import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:flutter/foundation.dart';

/// не забывать обновлять методы [User.toJson], [User.fromJson] и [User.toString] при изменении класса
@immutable
class User {
  final String phone;
  final bool isMobilePhoneConfirmed;
  final int id;

  final bool? isEmailConfirmed;

  final String? token;

  final String? name;
  final String? lastName;
  final String? secondName;
  final String? email;
  final String? pendingEmail;
  final DateTime? birthDate;
  final String? city;

  const User({
    required this.id,
    required this.phone,
    required this.isMobilePhoneConfirmed,
    this.isEmailConfirmed,
    this.token,
    this.name,
    this.lastName,
    this.secondName,
    this.email,
    this.pendingEmail,
    this.birthDate,
    this.city,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    try {
      return User(
        id: json['id'] as int,
        name: json['name'] as String?,
        token: json['token'] as String?,
        lastName: json['lastName'] as String?,
        secondName: json['secondName'] as String?,
        email: json['email'] as String?,
        phone: json['phone'] as String,
        pendingEmail: json['pendingEmail'] as String?,
        isMobilePhoneConfirmed: json['isMobilePhoneConfirmed'] as bool,
        birthDate: DateTime.tryParse(
          (json['birthDate'] as String? ?? '').split('+')[0],
        ),
        city: json['city'] as String?,
        isEmailConfirmed: json['isEmailConfirmed'] as bool?,
      );
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      throw ResponseParseException(e.toString());
    }
  }

  @override
  String toString() {
    return 'User(id: $id, token: $token, name: $name, lastName: $lastName, secondName: $secondName, email: $email, phone: $phone, isMobilePhoneConfirmed: $isMobilePhoneConfirmed, birthDate: $birthDate, city: $city, isEmailConfirmed: $isEmailConfirmed, pendingEmail: $pendingEmail)';
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'token': token,
        'name': name,
        'lastName': lastName,
        'secondName': secondName,
        'email': email,
        'phone': phone,
        'isMobilePhoneConfirmed': isMobilePhoneConfirmed,
        'birthDate': birthDate?.toIso8601String(),
        'city': city,
        'isEmailConfirmed': isEmailConfirmed,
        'pendingEmail': pendingEmail,
      };

  User copyWith({
    int? id,
    String? token,
    String? name,
    String? lastName,
    String? secondName,
    String? email,
    String? phone,
    bool? isMobilePhoneConfirmed,
    DateTime? birthDate,
    String? city,
    bool? isEmailConfirmed,
    String? pendingEmail,
  }) {
    return User(
      id: id ?? this.id,
      token: token ?? this.token,
      name: name ?? this.name,
      lastName: lastName ?? this.lastName,
      secondName: secondName ?? this.secondName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      isMobilePhoneConfirmed:
          isMobilePhoneConfirmed ?? this.isMobilePhoneConfirmed,
      birthDate: birthDate ?? this.birthDate,
      isEmailConfirmed: isEmailConfirmed ?? this.isEmailConfirmed,
      pendingEmail: pendingEmail ?? this.pendingEmail,
      city: city ?? this.city,
    );
  }
}
