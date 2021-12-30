import 'package:bausch/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppStyles {
  static final h1 = TextStyle(
    color: AppTheme.mineShaft,
    fontWeight: FontWeight.w500,
    fontSize: 21.sp,
    height: 25 / 21,
    fontFamily: 'Euclid Circular A',
  );

  static final h2Bold = TextStyle(
    color: AppTheme.mineShaft,
    fontWeight: FontWeight.w500,
    fontSize: 17.sp,
    height: 20 / 17,
    fontFamily: 'Euclid Circular A',
  );

  static final h2WhiteBold = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w500,
    fontSize: 17.sp,
    height: 20 / 17,
    fontFamily: 'Euclid Circular A',
  );

  static final h2GreyBold = TextStyle(
    color: AppTheme.grey,
    fontWeight: FontWeight.w500,
    fontSize: 17.sp,
    height: 20 / 17,
    fontFamily: 'Euclid Circular A',
  );

  static final h2 = TextStyle(
    color: AppTheme.mineShaft,
    fontWeight: FontWeight.w500,
    fontSize: 17.sp,
    height: 20 / 17,
    fontFamily: 'Euclid Circular A',
  );

  static final h3 = TextStyle(
    color: AppTheme.mineShaft,
    fontWeight: FontWeight.w400,
    fontSize: 17.sp,
    height: 20 / 17,
    fontFamily: 'Euclid Circular A',
  );

  static final p1 = TextStyle(
    color: AppTheme.mineShaft,
    fontWeight: FontWeight.w400,
    fontSize: 14.sp,
    height: 20 / 14,
    fontFamily: 'Euclid Circular A',
  );

  static final p1Grey = TextStyle(
    color: AppTheme.grey,
    fontWeight: FontWeight.normal,
    fontSize: 14.sp,
    height: 20 / 14,
    fontFamily: 'Euclid Circular A',
  );

  static final p1White = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.normal,
    fontSize: 14.sp,
    height: 20 / 14,
    fontFamily: 'Euclid Circular A',
  );

  static final p1Underlined = TextStyle(
    color: const Color(0xFF2D2D2D),
    fontWeight: FontWeight.normal,
    fontSize: 14.sp,
    height: 20 / 14,
    decoration: TextDecoration.underline,
    decorationColor: AppTheme.turquoiseBlue,
    decorationThickness: 2,
    fontFamily: 'Euclid Circular A',
  );

  static final p2 = TextStyle(
    color: AppTheme.mineShaft,
    fontWeight: FontWeight.normal,
    fontSize: 12.sp,
    height: 14 / 12,
    fontFamily: 'Euclid Circular A',
  );

  static final n1 = TextStyle(
    color: AppTheme.mineShaft,
    fontWeight: FontWeight.w400,
    fontSize: 12.sp,
    height: 14 / 12,
    fontFamily: 'Euclid Circular A',
  );
}
