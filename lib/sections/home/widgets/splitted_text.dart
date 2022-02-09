// ignore_for_file: avoid_redundant_argument_values, cascade_invocations, one_member_abstracts

import 'dart:ui';
import 'package:flutter/cupertino.dart';

abstract class SplittedText {
  List<String> getSplittedText(
    double maxWidth,
    TextStyle textStyle,
    String text,
  );
}

class SplittedTextImpl extends SplittedText {
  @override
  List<String> getSplittedText(
    double maxWidth,
    TextStyle textStyle,
    String text,
  ) {
    final lineTexts = <String>[];
    final textSpan = TextSpan(text: text, style: textStyle);
    final _textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    _textPainter.layout(
      maxWidth: maxWidth,
    );

    final selection =
        TextSelection(baseOffset: 0, extentOffset: textSpan.text!.length);

    final boxes = _textPainter.getBoxesForSelection(selection);

    var start = 0;
    int end;

    final reg = RegExp('[^А-Яа-яA-Za-z0-9().,;?]');

    for (final box in boxes) {
      end = _textPainter
          .getPositionForOffset(
            Offset(
              box.left,
              box.bottom,
            ),
          )
          .offset;

      final line = text.substring(
        start,
        end,
      );
      if (line.isNotEmpty) {
        lineTexts.add(line.replaceAll(reg, ' '));
      }
      start = end;
    }

    final extra = text.substring(start);
    lineTexts.add(extra.replaceAll(reg, ' '));

    return lineTexts;
  }
}
