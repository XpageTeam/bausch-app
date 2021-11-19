import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/models/mappable_object.dart';

class SocialModel implements MappableInterface<SocialModel> {
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

    return SocialModel(
      id: map['id'] as int,
      icon: map['icon'] as String,
      url: map['url'] as String,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    throw UnimplementedError();
  }
}
