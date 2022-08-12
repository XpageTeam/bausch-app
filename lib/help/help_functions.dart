import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HelpFunctions {
  static String wordByCount(int count, List<String> words) {
    final countStr = '0${count.toString()}';
    debugPrint(countStr);
    var prefix = words[0];

    if (RegExp(r'^([\d]*[02-9])?1$').firstMatch(countStr) != null) {
      prefix = words[1];
    } else if (RegExp(r'^[\d]*[02-9][2-4]$').firstMatch(countStr) != null) {
      prefix = words[2];
    }

    return prefix;
  }

  static Future<void> launchURL(String url) async {
    // ignore: only_throw_errors
    if (!await launchUrlString(url)) throw 'Could not launch $url';
  }

  static String partitionNumber(num number) {
    final parts = number.toString().split('.');
    final reg = RegExp(r'\B(?=(\d{3})+(?!\d))');

    parts[0] = parts[0].replaceAll(reg, ' ');

    return parts.join('.');
  }

  static String formatPhone(String phone) {
    final regex = RegExp('[^0-9]');
    final cleanPhone = phone.replaceAll(regex, '');
    if (cleanPhone.length != 11) {
      return cleanPhone;
    }
    final res =
        '${cleanPhone.substring(0, 1) == '7' ? '+' : ''}${cleanPhone.substring(0, 1)} ${cleanPhone.substring(1, 4)} ${cleanPhone.substring(4, 7)}-${cleanPhone.substring(7, 9)}-${cleanPhone.substring(9)}';

    return res;
  }

  static List<String> getSplittedText(
    double maxWidth,
    TextStyle textStyle,
    String text,
  ) {
    final lineTexts = <String>[];
    final textSpan = TextSpan(text: text, style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    )..layout(
        maxWidth: maxWidth,
      );

    final selection = TextSelection(
      baseOffset: 0,
      extentOffset: textSpan.text!.length,
    );

    final boxes = textPainter.getBoxesForSelection(selection);

    var start = 0;
    int end;

    final reg = RegExp('[^А-Яа-яA-Za-z0-9().,;?]');

    for (final box in boxes) {
      end = textPainter
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

extension NumberPartition on int {
  String get formatString => HelpFunctions.partitionNumber(this);
}
