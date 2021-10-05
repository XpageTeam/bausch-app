import 'package:bausch/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppStyles {
  static const h2 = TextStyle(
    color: Color(0xFF2D2D2D),
    fontWeight: FontWeight.w500,
    fontSize: 21,
    height: 25 / 21,
  );

  static const h3 = TextStyle(
    color: Color(0xFF2D2D2D),
    fontWeight: FontWeight.w500,
    fontSize: 17,
    height: 20 / 17,
  );

  static const h4 = TextStyle(
    color: Color(0xFF2D2D2D),
    fontWeight: FontWeight.normal,
    fontSize: 17,
    height: 20 / 17,
  );

  static const p1 = TextStyle(
    color: Color(0xFF2D2D2D),
    fontWeight: FontWeight.normal,
    fontSize: 14,
    height: 20 / 14,
  );

  static const p1Underlined = TextStyle(
    color: Color(0xFF2D2D2D),
    fontWeight: FontWeight.normal,
    fontSize: 14,
    height: 20 / 14,
    decoration: TextDecoration.underline,
    decorationColor: AppTheme.turquoiseBlue,
    decorationThickness: 2,
  );

  static const p1Grey = TextStyle(
    color: AppTheme.grey,
    fontWeight: FontWeight.normal,
    fontSize: 14,
    height: 20 / 14,
  );

  static const p2 = TextStyle(
    color: Color(0xFF2D2D2D),
    fontWeight: FontWeight.normal,
    fontSize: 12,
    height: 14 / 12,
  );
}
