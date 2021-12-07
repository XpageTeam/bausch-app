import 'package:bausch/exceptions/response_parse_exception.dart';
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
  final String phone;

  ///* Сайт
  final String? site;

  ///* Координаты магазина
  final Point? coords;

  ///* Метка для отображения на карте
  Placemark? placemark;

  ShopModel({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    this.site,
    this.coords,
    this.placemark,
  });

  factory ShopModel.fromJson(Map<String, dynamic> map) {
    if (map['id'] == null) {
      throw ResponseParseException('У магазина отсутствует идентификатор');
    }

    return ShopModel(
      id: map['id'] as int,
      name: map['name'] as String,
      address: map['address'] as String,
      // TODO(Nikolay): Номера.
      phone: (map['phone'] as List<dynamic>)[0] as String,
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
