import 'dart:async';
import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

@immutable
class LoginText {
  final String text;
  final Map<String, String>? docs;

  Widget get linkText {
    if (docs == null) {
      return Text(
        text,
        style: AppStyles.p1,
      );
    }

    return RichText(
      text: TextSpan(
        style: AppStyles.p1.copyWith(
          color: Colors.transparent,
          shadows: const [
            BoxShadow(
              color: AppTheme.mineShaft,
              offset: Offset(0, -2),
            ),
          ],
        ),
        children: _splitedText(),
      ),
    );
  }

  const LoginText({
    required this.text,
    this.docs,
  });

  factory LoginText.fromJson(Map<String, dynamic> json) {
    try {
      final docs = <String, String>{};

      if (json['docs'] != null) {
        // ignore: avoid_annotating_with_dynamic
        (json['docs'] as Map<String, dynamic>).forEach((key, dynamic value) {
          docs.addAll({
            key: value as String,
          });
        });
      }

      return LoginText(
        text: json['text'] as String,
        docs: docs,
      );
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      throw ResponseParseException(e.toString());
    }
  }

  @override
  String toString() => 'LoginText(text: $text, docs: $docs)';

  Map<String, dynamic> toJson() => <String, dynamic>{
        'text': text,
        'docs': docs,
      };

  List<InlineSpan> _splitedText() {
    final res = <InlineSpan>[];
    var nextText = text;

    docs!.forEach((key, value) {
      final splittedText = nextText.split(key);

      nextText = splittedText[1];

      res.addAll(_getTexts(
        text: splittedText[0],
        link: value,
        linkText: key,
        currentList: res,
      ));
    });

    return res;
  }

  List<InlineSpan> _getTexts({
    required String text,
    required String link,
    required String linkText,
    List<InlineSpan> currentList = const [],
  }) {
    return [
      TextSpan(
        text: text,
      ),
      TextSpan(
        style: const TextStyle(
          decoration: TextDecoration.underline,
          decorationColor: Color(0xFF60D7E2),
          decorationThickness: 2,
        ),
        text: linkText,
        recognizer: TapGestureRecognizer()
          ..onTap = () async {
            if (await canLaunchUrlString(link)) {
              unawaited(launchUrlString(link));
            }
          },
      ),
    ];
  }
}
