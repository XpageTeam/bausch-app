import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/help/help_functions.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

//* Заглушка
class ShopModel {
  ///* Идентификатор магазина
  final int id;

  ///* Название магазина
  final String name;

  ///* Адрес магазина
  final String address;

  ///* Телефон
  final List<String> phones;

  ///* Сайт
  final String? site;

  ///* Координаты магазина
  final Point? coords;

  ShopModel({
    required this.id,
    required this.name,
    required this.address,
    required this.phones,
    this.site,
    this.coords,
  });

  factory ShopModel.fromJson(Map<String, dynamic> map) {
    if (map['id'] == null) {
      throw ResponseParseException('У магазина отсутствует идентификатор');
    }

    return ShopModel(
      id: map['id'] as int,
      name: map['name'] as String,
      address: map['address'] as String,
      phones: (map['phone'] as List<dynamic>)
          .map(
            // ignore: avoid_annotating_with_dynamic
            (dynamic e) => HelpFunctions.formatPhone(e as String),
          )
          .toList(),
      site: map['site'] as String?,
      coords: map['coordinates'] != null
          ? Point(
              latitude:
                  (map['coordinates'] as Map<String, dynamic>)['lat'] as double,
              longitude:
                  (map['coordinates'] as Map<String, dynamic>)['lon'] as double,
            )
          : null,
    );
  }
}
