import 'package:flutter/cupertino.dart';

class StaticData {
  static const sidePadding = 12.0;
}

enum SheetWithItemsType {
  webinar,
  packaging,
  discountOptics,
  discountOnline,
  partners,
}

enum SheetType {
  consultation,
  addpoints,
  program,
}

class Keys {
  //* Ключ для навигации между страницами приложения
  static GlobalKey<NavigatorState> mainContentNav = GlobalKey();

  //* Ключ для навигации между страницами bottomSheet'а, на которых есть элементы каталога(CatalogItem)
  static GlobalKey<NavigatorState> bottomSheetItemsNav = GlobalKey();

  //* Ключ для навигации между страницами bottomSheet'а, на которых нет элементов каталога
  //* Т.е. сразу открывается нужная страница
  static GlobalKey<NavigatorState> bottomSheetNav = GlobalKey();

  //* Ключ для контроля всяких всплывающих виджетов
  static GlobalKey<NavigatorState> mainNav = GlobalKey();
}
