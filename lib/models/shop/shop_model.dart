import 'package:yandex_mapkit/yandex_mapkit.dart';

//* Заглушка
class ShopModel {
  //* Тестовые координаты магазинов
  static const _shopsCoords = [
    Point(latitude: 55.153596, longitude: 61.390849),
    Point(latitude: 55.157433, longitude: 61.389645),
    Point(latitude: 55.164274, longitude: 61.396131),
    Point(latitude: 55.162664, longitude: 61.424410),
  ];

  ///* Идентификатор магазина
  final int id;

  ///* Название магазина
  final String name;

  ///* Адрес магазина
  final String address;

  final String phone;

  ///* Координаты магазина
  final Point? coords;

  // TODO(Nikolay): ↑ Координаты хранятся и здесь, дублирование получается.↓

  ///* Метка для отображения на карте
  Placemark? placemark;

  ShopModel({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    this.placemark,
    this.coords,
  });

  factory ShopModel.test([int idx = 0]) {
    return ShopModel(
      id: idx,
      name: 'ЛинзСервис $idx',
      address: 'ул. Задарожная, д. 20, к. 2, ТЦ Океания',
      phone: '+7 920 325-62-26',
      coords: _shopsCoords[idx % _shopsCoords.length],
    );
  }

  static List<ShopModel> generate([int length = 3]) {
    return List<ShopModel>.generate(
      length,
      (i) => ShopModel.test(i),
    );
  }
}
