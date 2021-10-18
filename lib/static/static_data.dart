import 'package:flutter/cupertino.dart';

class StaticData {
  static const sidePadding = 12.0;
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
