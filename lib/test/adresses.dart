import 'package:bausch/models/adress_model.dart';

class Adresses {
  static List<String> cities = [
    'Аша',
    'Москва',
    'Свердловск',
    'Владимир',
    'Владивосток',
    'Челябинск',
    'Казань',
    'Магнитогорск',
    'Минск',
    'Киев',
    'Севастополь',
  ];

  static List<String> streets = [
    'Александра Чавчавадзе, 9',
    'Александра Чавчавадзе, 8 ',
    'Проспект Победы, 9 ',
    'Мира, 9 ',
  ];

  static List<AdressModel> adresses = [
    AdressModel(street: 'shbdhb', office: 5, floor: 3, lobby: 5),
  ];
}
