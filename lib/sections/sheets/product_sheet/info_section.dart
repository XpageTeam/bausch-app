import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class InfoSection extends StatelessWidget {
  final String? text;
  const InfoSection({this.text, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 12,
          right: 12,
          top: 20,
          bottom: 40,
        ),
        child: Column(
          children: [
            Html(
              data: text ?? 'text',
              style: {
                'body': Style(
                  padding: EdgeInsets.zero,
                  color: AppTheme.mineShaft,
                  fontWeight: FontWeight.w400,
                  fontSize: const FontSize(14),
                  lineHeight: LineHeight(20 / 14),
                ),
              },
            ),
          ],
        ),
      ),
    );
  }
}
