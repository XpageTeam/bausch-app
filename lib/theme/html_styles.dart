import 'package:bausch/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/style.dart';

final Map<String, Style> htmlStyles = {
  'a': Style(
    color: AppTheme.mineShaft,
    display: Display.INLINE,
    textDecoration: TextDecoration.underline,
    textDecorationColor: AppTheme.turquoiseBlue,
  ),
  'body': Style(
    padding: EdgeInsets.zero,
    margin: EdgeInsets.zero,
    color: AppTheme.mineShaft,
    fontWeight: FontWeight.w400,
    fontSize: FontSize.medium,
    lineHeight: const LineHeight(20 / 14),
  ),
  'ul': Style(
    padding: EdgeInsets.zero,
  ),
  'li:not(:first-child)': Style(
    margin: const EdgeInsets.only(top: 10),
  ),
  'li': Style(
    padding: const EdgeInsets.only(left: 6),
    listStylePosition: ListStylePosition.OUTSIDE,
  ),
};

final Map<String, Style> storyStyles = {
  'a': Style(
    color: AppTheme.mineShaft,
    display: Display.INLINE,
    textDecoration: TextDecoration.underline,
    textDecorationColor: AppTheme.turquoiseBlue,
  ),
  'body': Style(
    padding: EdgeInsets.zero,
    margin: EdgeInsets.zero,
    color: Colors.white,
    fontWeight: FontWeight.w500,
    fontSize: const FontSize(17),
    lineHeight: const LineHeight(20 / 17),
  ),
  'ul': Style(
    padding: EdgeInsets.zero,
  ),
  // 'li:not(:first-child)': Style(
  //   margin: const EdgeInsets.only(top: 10),
  // ),
  'li': Style(
    padding: const EdgeInsets.only(left: 6),
    margin: const EdgeInsets.only(top: 10),
    listStylePosition: ListStylePosition.OUTSIDE,
  ),
};

// {
//   'body': Style(
//     padding: const EdgeInsets.symmetric(
//       horizontal: StaticData.sidePadding,
//     ),
//     margin: const EdgeInsets.all(0),
//     color: AppTheme.mineShaft,
//     fontWeight: FontWeight.w400,
//     fontSize: const FontSize(14),
//     lineHeight: const LineHeight(20 / 14),
//   ),
//   'b': Style(
//     padding: EdgeInsets.zero,
//     color: AppTheme.mineShaft,
//     fontWeight: FontWeight.w500,
//     fontSize: const FontSize(17),
//     lineHeight: const LineHeight(20 / 17),
//     margin: const EdgeInsets.all(0),
//   ),
//   'div': Style(
//     padding: EdgeInsets.zero,
//     margin: const EdgeInsets.all(0),
//   ),
// },

// 'body': Style(
//   padding: const EdgeInsets.symmetric(
//     horizontal:
//         StaticData.sidePadding, //StaticData.sidePadding,
//   ),
//   color: AppTheme.mineShaft,
//   fontWeight: FontWeight.w400,
//   fontSize: const FontSize(14),
//   lineHeight: const LineHeight(20 / 17),
//   margin: const EdgeInsets.all(0),
// ),
// 'br': Style(
//   padding: EdgeInsets.zero,
//   //margin: const EdgeInsets.all(0),
// ),
// 'p': Style(
//   padding: EdgeInsets.zero,
//   //margin: EdgeInsets.zero,
// ),
// 'li': Style(
//   padding: EdgeInsets.zero,
//   //margin: EdgeInsets.zero,
// ),
// 'a': Style(
//   color: AppTheme.mineShaft,
//   fontWeight: FontWeight.w400,
//   fontSize: const FontSize(14),
//   lineHeight: const LineHeight(20 / 14),
//   textDecorationColor: AppTheme.turquoiseBlue,
//   //margin: const EdgeInsets.all(0),
// ),