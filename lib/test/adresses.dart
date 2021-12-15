import 'package:bausch/models/profile_settings/adress_model.dart';

class Adresses {

  static List<String> streets = [
    'Александра Чавчавадзе, 9',
    'Александра Чавчавадзе, 8 ',
    'Проспект Победы, 9 ',
    'Мира, 9 ',
  ];

  static List<AdressModel> adresses = [
    AdressModel(
        street: 'Александра Чавчавадзе',
        house: '9',
        flat: 2,
        entry: 2,
        floor: 5),
    AdressModel(
        street: 'Александра Чавчавадзе',
        house: '10',
        flat: 3,
        entry: 4,
        floor: 5),
    AdressModel(street: 'Мира', house: '56', flat: 3, entry: 4, floor: 5),
  ];
}
