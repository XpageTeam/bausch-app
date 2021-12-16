// ignore_for_file: use_named_constants

import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class InfoSection extends StatelessWidget {
  final String? text;
  final String? secondText;

  const InfoSection({this.text, this.secondText, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (text != null) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            //left: 12,
            //right: 12,
            top: 20,
            bottom: 40,
          ),
          child: Column(
            children: [
              Html(
                data: text,
                style: {
                  'body': Style(
                    padding: const EdgeInsets.symmetric(
                      horizontal: StaticData.sidePadding,
                    ),
                    color: AppTheme.mineShaft,
                    fontWeight: FontWeight.w400,
                    fontSize: const FontSize(14),
                    lineHeight: const LineHeight(20 / 14),
                  ),
                  'br': Style(
                    padding: EdgeInsets.zero,
                  ),
                  'a': Style(
                    color: AppTheme.mineShaft,
                    fontWeight: FontWeight.w400,
                    fontSize: const FontSize(14),
                    lineHeight: const LineHeight(20 / 14),
                    textDecorationColor: AppTheme.turquoiseBlue,
                  ),
                },
              ),
              if (secondText != null)
                const SizedBox(
                  height: 40,
                ),
              if (secondText != null)
                Html(
                  data: secondText,
                  style: {
                    'body': Style(
                      padding: const EdgeInsets.symmetric(
                        horizontal: StaticData.sidePadding,
                      ),
                      color: AppTheme.mineShaft,
                      fontWeight: FontWeight.w400,
                      fontSize: const FontSize(14),
                      lineHeight: const LineHeight(20 / 14),
                    ),
                    'b': Style(
                      padding: EdgeInsets.zero,
                      color: AppTheme.mineShaft,
                      fontWeight: FontWeight.w500,
                      fontSize: const FontSize(17),
                      lineHeight: const LineHeight(20 / 17),
                    ),
                    'div': Style(
                      padding: EdgeInsets.zero,
                    ),
                  },
                ),
            ],
          ),
        ),
      );
    }

    return Container();
  }

  //TODO: УБРАТЬ!!!
  // String txt(String? text) {
  //   if (text != null) {
  //     if (text.isNotEmpty) {
  //       return text;
  //     } else {
  //       return 'Однодневные контактные линзы из инновационного материала гипергель53, влагосодержание которого соответствует количеству воды в роговице глаза человека — 78%52.';
  //     }
  //   } else {
  //     return 'Однодневные контактные линзы из инновационного материала гипергель53, влагосодержание которого соответствует количеству воды в роговице глаза человека — 78%52.';
  //   }
  // }
}
