// ignore_for_file: avoid_catches_without_on_clauses

import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/help/help_functions.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
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
    var number = 1;

    if (ctx.tree.element?.parent?.localName == 'ol') {
      var counter = 0;
      for (final element in ctx.tree.element!.parent!.children) {
        // final el = element as Element;
        counter++;
        if (element == ctx.tree.element!) {
          break;
        }
      }

      number = counter;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (ctx.tree.element?.parent?.localName != 'ol')
            Container(
              margin: const EdgeInsets.only(
                right: 14,
                top: 7,
              ),
              child: CircleAvatar(
                radius: 3,
                backgroundColor: ctx.tree.style.color,
              ),
            ),
          Flexible(
            child: Text(
              ctx.tree.element?.parent?.localName != 'ol'
                  ? ctx.tree.element?.text ?? ''
                  : '$number. ${ctx.tree.element?.text}',
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
  // 'td': (context, widget) {
  //   return Container(
  //     constraints: BoxConstraints(
  //       maxWidth: MediaQuery.of(context.buildContext).size.width - 80,
  //     ),
  //     child: Text(
  //       context.tree.element?.text ?? '',
  //     ),
  //   );
  // },
  'table': (context, child) {
    const color = AppTheme.turquoiseBlue;

    context.tree as TableLayoutElement;

    for (var i = 0; i < context.tree.children.length; i++) {
      //debugPrint('$i ${(context.tree as TableLayoutElement).children[i]}');
      for (var j = 0; j < context.tree.children[i].children.length; j++) {
        for (var k = 0;
            k < context.tree.children[i].children[j].children.length;
            k++) {
          // context.tree.children[i].children[j].children[k].element?.attributes = '';

          context.tree.children[i].children[j].children[k].style = Style(
            padding: const EdgeInsets.all(2),
            border: Border(
              bottom: const BorderSide(color: color),
              top: j != 1 ? BorderSide.none : const BorderSide(color: color),
              left: k == 0 ? BorderSide.none : const BorderSide(color: color),
              right: ((k == 0) ||
                      (k ==
                          context.tree.children[i].children[j].children.length -
                              2))
                  ? const BorderSide(color: color)
                  : BorderSide.none,
            ),
          );

          // final splitedText = HelpFunctions.getSplittedText(
          //   MediaQuery.of(context.buildContext).size.width -
          //       MediaQuery.of(context.buildContext).size.width / 4,
          //   AppStyles.h1,
          //   context.tree.children[i].children[j].children[k].element?.text ??
          //       '',
          // );

          // var text = '';

          // for (final string in splitedText) {
          //   text += '$string \r\n';
          // }

          // context.tree.children[i].children[j].children[k].element?.text = text;
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
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context.buildContext).size.width * 4,
        ),
        child: (context.tree as TableLayoutElement).toWidget(context),
      ),
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
    );
  },

  'img': (ctx, widget) {
    var imgUrl = ctx.tree.element!.attributes['src'] ?? '';

    if (!imgUrl.startsWith('http')) {
      imgUrl = '${StaticData.defaultImageSource}$imgUrl';
    }

    // if (imgUrl == null && imgUrl.isEmpty) return const SizedBox();

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
