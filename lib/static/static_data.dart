import 'package:flutter/cupertino.dart';

class StaticData {
  static const sidePadding = 12.0;

  static const contraindications =
      'Имеются противопоказания, необходимо проконсультироваться со специалистом';

  static const deliveryInfoStrings = [
    'Адрес доставки должен быть на территории Российской Федерации, за исключением Республики Крым (по правилам программы доставка в Крым и Севастополь не осуществляется).',
    'Бесплатная упаковка будет направлена на указанный адрес не позднее 60 рабочих дней с момента заказа.',
    'Организатор не несёт ответственность за невозможность доставки в связи с некорректным указанием адреса доставки и в случае невозможности связаться с получателем по указанному номеру телефона. Сроки доставки определяются организацией, осуществляющей доставку.',
    'Внешний вид и комплектность подарочных изделий могут отличаться от изображений на сайте.',
  ];


}

enum SheetType {
  webinar,
  packaging,
  discountOptics,
  discountOnline,
  partners,
  consultations,
}

class Keys {
  //* Ключ для навигации между страницами приложения
  static GlobalKey<NavigatorState> mainContentNav = GlobalKey();

  //* Ключ для навигации между страницами bottomSheet'а
  static GlobalKey<NavigatorState> bottomSheetNav = GlobalKey();

  //* Ключ для контроля всяких всплывающих виджетов
  static GlobalKey<NavigatorState> mainNav = GlobalKey();
}
