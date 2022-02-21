// ignore_for_file: avoid_catches_without_on_clauses

import 'package:bausch/exceptions/response_parse_exception.dart';

class SocialModel {
  final int id;

  //* Ссылка на иконку соц.сети
  final String icon;

  //* Ссылка на аккаунт
  final String url;

  SocialModel({
    required this.id,
    required this.icon,
    required this.url,
  });

  factory SocialModel.fromMap(Map<String, dynamic> map) {
    if (map['id'] == null) {
      throw ResponseParseException('Не передан идентификатор');
    }
    if (map['icon'] == null) {
      throw ResponseParseException('Не передана ссылка на иконку');
    }
    if (map['url'] == null) {
      throw ResponseParseException('Не передана ссылка на страницу');
    }

    try {
      return SocialModel(
        id: map['id'] as int,
        icon: map['icon'] as String,
        url: map['url'] as String,
      );
    } catch (e) {
      throw ResponseParseException('SocialModel: $e');
    }
  }
}
