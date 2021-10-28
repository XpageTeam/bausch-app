import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/widgets/text/text_with_point.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class LegalInfo extends StatelessWidget {
  final String? text;
  const LegalInfo({this.text, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: Column(
        children: [
          Html(
            data: text ?? 'text',
            style: {
              'body': Style(
                padding: EdgeInsets.zero,
                color: AppTheme.grey,
                fontWeight: FontWeight.normal,
                fontSize: const FontSize(14),
                lineHeight: LineHeight(20 / 14),
              ),
            },
          ),
        ],
      ),
    );
  }
}
