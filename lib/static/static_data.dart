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

class Utils {
  static GlobalKey<NavigatorState> mainAppNav = GlobalKey();
  static GlobalKey<NavigatorState> bottomSheetNav = GlobalKey();
}
