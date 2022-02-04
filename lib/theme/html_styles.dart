// ignore_for_file: avoid_catches_without_on_clauses

import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';

final Map<String, Style> htmlStyles = {
  'a': Style(
    color: AppTheme.mineShaft,
    textDecoration: TextDecoration.underline,
    textDecorationColor: AppTheme.turquoiseBlue,
  ),
  'body': Style(
    padding: EdgeInsets.zero,
    margin: EdgeInsets.zero,
    color: AppTheme.mineShaft,
    fontWeight: FontWeight.w400,
    fontSize: FontSize.medium,
    fontFamily: 'Euclid Circular A',
    lineHeight: const LineHeight(20 / 14),
  ),
  'ul': Style(
    padding: EdgeInsets.zero,
  ),
};

final storyTextHtmlStyles = <String, Style>{
  'a': Style(
    color: Colors.white,
    textDecoration: TextDecoration.underline,
    textDecorationColor: Colors.white,
  ),
  'body': Style(
    padding: EdgeInsets.zero,
    margin: EdgeInsets.zero,
    color: Colors.white,
    fontWeight: FontWeight.w400,
    fontSize: FontSize.medium,
    fontFamily: 'Euclid Circular A',
    lineHeight: const LineHeight(20 / 14),
  ),
  'ul': Style(
    padding: EdgeInsets.zero,
  ),
};

final storyTextAfterHtmlStyles = <String, Style>{
  'a': Style(
    color: const Color(0xFF797B7C),
    textDecoration: TextDecoration.underline,
    textDecorationColor: const Color(0xFF797B7C),
  ),
  'body': Style(
    padding: EdgeInsets.zero,
    margin: EdgeInsets.zero,
    color: const Color(0xFF797B7C),
    fontWeight: FontWeight.w400,
    fontSize: const FontSize(12),
    fontFamily: 'Euclid Circular A',
    lineHeight: const LineHeight(14 / 12),
  ),
  'ul': Style(
    padding: EdgeInsets.zero,
  ),
};

Map<String, dynamic Function(RenderContext, Widget)> htmlCustomRender = {
  'li': (ctx, widget) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(
              right: 14,
              top: 7,
            ),
            child: const CircleAvatar(
              radius: 3,
              backgroundColor: AppTheme.mineShaft,
            ),
          ),
          Flexible(
            child: Text(
              ctx.tree.element!.text,
              style: TextStyle(
                fontFamily: ctx.tree.style.fontFamily,
                fontSize: ctx.tree.style.fontSize?.size ?? 14,
                color: ctx.tree.style.color,
                height: ctx.tree.style.lineHeight?.size ?? 20 / 14,
              ),
            ),
          ),
        ],
      ),
    );
  },
  //(context.tree as TableLayoutElement).children
  'table': (context, child) {
    const color = AppTheme.turquoiseBlue;
    for (var i = 0;
        i < (context.tree as TableLayoutElement).children.length;
        i++) {
      //debugPrint('$i ${(context.tree as TableLayoutElement).children[i]}');
      for (var j = 0;
          j < (context.tree as TableLayoutElement).children[i].children.length;
          j++) {
        for (var k = 0;
            k <
                (context.tree as TableLayoutElement)
                    .children[i]
                    .children[j]
                    .children
                    .length;
            k++) {
          (context.tree as TableLayoutElement)
              .children[i]
              .children[j]
              .children[k]
              .style = Style(
            padding: const EdgeInsets.all(2),
            border: Border(
              bottom: const BorderSide(color: color),
              top: j != 1 ? BorderSide.none : const BorderSide(color: color),
              left: k == 0 ? BorderSide.none : const BorderSide(color: color),
              right: ((k == 0) ||
                      (k ==
                          (context.tree as TableLayoutElement)
                                  .children[i]
                                  .children[j]
                                  .children
                                  .length -
                              2))
                  ? const BorderSide(color: color)
                  : BorderSide.none,
            ),
          );
        }
      }
    }

    // (context.tree as TableLayoutElement)
    //     .children
    //     .forEach((child) => child.children.forEach((element) {
    //           element.children.forEach((el) {
    //             debugPrint(el.element!.text);
    //           });
    //         }));

    return SingleChildScrollView(
      clipBehavior: Clip.none,
      child: (context.tree as TableLayoutElement).toWidget(
        context,
      ),
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
    );
  },

  'img': (ctx, widget) {
    //debugPrint(ctx.tree.element!.attributes['src']);

    final imgUrl = ctx.tree.element!.attributes['src'];

    if (imgUrl == null && imgUrl!.isEmpty) return const SizedBox();

    try {
      if (imgUrl.endsWith('.svg')) {
        return SvgPicture.network(
          imgUrl,
        );
      }
      return Image.network(imgUrl);
    } catch (e) {
      throw const CustomException(
        title: 'Невозможно открыть картинку по ссылке',
      );
    }
  },
};

/*
final Map<String, Style> storyStyles = {
  'a': Style(
    color: AppTheme.mineShaft,
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
};*/

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
