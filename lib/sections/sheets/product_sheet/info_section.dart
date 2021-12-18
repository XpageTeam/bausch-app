// ignore_for_file: use_named_constants

import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/html_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class InfoSection extends StatelessWidget {
  final String text;
  final String secondText;

  const InfoSection({
    required this.text,
    required this.secondText,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (text.isNotEmpty) {
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
                style: htmlStyles,
              ),
              if (secondText.isNotEmpty)
                const SizedBox(
                  height: 40,
                ),
              if (secondText.isNotEmpty)
                Html(
                  data: secondText,
                  style: htmlStyles,
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
