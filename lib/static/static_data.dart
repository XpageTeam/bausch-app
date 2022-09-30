import 'package:flutter/material.dart';

class StaticData {
  static const defaultImageSource = 'http://ultralinzi.ru/';

  static const privacyPolicyLink = 'https://ultralinzi.ru/upload/politika_o_konfidencialnosty.pdf';

  static const dadataApiKey = 'c5884c57a17def3fe99c96a9ee13b15554680669';
  // ignore: use_raw_strings
  static const dadataSecretKey = 'R_SHe3@bFx\$DOP28yrMgm_%&M';

  static const sidePadding = 12.0;

  static const contraindications =
      'Имеются противопоказания, необходимо проконсультироваться со специалистом';

  static const deliveryInfoStrings = [
    'Адрес доставки должен быть на территории Российской Федерации, за исключением Республики Крым (по правилам программы доставка в Крым и Севастополь не осуществляется).',
    'Бесплатная упаковка будет направлена на указанный адрес не позднее 60 рабочих дней с момента заказа.',
    'Организатор не несёт ответственность за невозможность доставки в связи с некорректным указанием адреса доставки и в случае невозможности связаться с получателем по указанному номеру телефона. Сроки доставки определяются организацией, осуществляющей доставку.',
    'Внешний вид и комплектность подарочных изделий могут отличаться от изображений на сайте.',
  ];

  static const removedOffersKey = 'removed_offers';

  static String apiUrl = 'https://bausch.in-progress.ru/api/';


  

  /// Названия типов разделов, чтобы не менять во всех местах
  static Map<String, String> types = {
    'webinar': 'promo_code_video',
    'consultation': 'online_consultation',
    'discount_optics': 'offline',
    'discount_online': 'onlineShop',
    'partners': 'promo_code_immediately',
  };

  static List<String> fileTypes = [
    'png',
    'jpg',
    'jpeg',
    'pdf',
    // 'doc',
    // 'docx',
    // 'xls',
    // 'xlsx',
    // 'mp4',
    // 'avi',
    // 'mov',
  ];

  static int maxFileSize = 5 * 1024 * 1024;

  static String maxFilesSizeText = 'Размер файла не должен превышать 5мб';
}

/// Типы экранов с элементами каталога
enum SheetWithItemsType {
  webinar,
  packaging,
  discountOptics,
  discountOnline,
  partners,
}

/// Типы экранов без элементов каталога
enum SheetWithoutItemsType {
  consultation,
  addpoints,
  program,
}

/// Типы экранов, где элементы каталога никак не участвуют вообще
enum SimpleSheetType {
  faq,
  links,
  rules,
  addpoints,
  program,
}

/// Ключ для того, чтобы можно было проскроллить на позицию с секцией "Потратить баллы"
GlobalKey spendPointsPositionKey = GlobalKey();

class Keys {
  //* Ключ для навигации между страницами приложения
  static GlobalKey<NavigatorState> mainContentNav = GlobalKey();

  //* Ключ для контроля всяких всплывающих виджетов
  static GlobalKey<NavigatorState> mainNav = GlobalKey();

  //* Ключ для навигации в bottomSheet'ах
  static GlobalKey<NavigatorState> bottomNav = GlobalKey();
}
