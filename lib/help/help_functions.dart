import 'package:flutter/material.dart';

class HelpFunctions {
  static String getMonthNameByNumber(
    int month, {
    bool parent = true,
    bool fullLength = false,
  }) {
    if (fullLength) {
      switch (month) {
        case 2:
          return parent ? 'февраля' : 'февраль';
        case 3:
          return parent ? 'марта' : 'март';
        case 4:
          return parent ? 'апреля' : 'апрель';
        case 5:
          return parent ? 'мая' : 'май';
        case 6:
          return parent ? 'июня' : 'июнь';
        case 7:
          return parent ? 'июля' : 'июль';
        case 8:
          return parent ? 'августа' : 'август';
        case 9:
          return parent ? 'сентября' : 'сентябрь';
        case 10:
          return parent ? 'октября' : 'октябрь';
        case 11:
          return parent ? 'ноября' : 'ноябрь';
        case 12:
          return parent ? 'декабря' : 'декабрь';

        case 1:
        default:
          return parent ? 'января' : 'январь';
      }
    } else {
      switch (month) {
        case 2:
          return 'февр.';
        case 3:
          return parent ? 'марта' : 'март';
        case 4:
          return 'апр.';
        case 5:
          return parent ? 'мая' : 'май';
        case 6:
          return parent ? 'июня' : 'июнь';
        case 7:
          return parent ? 'июля' : 'июль';
        case 8:
          return 'авг.';
        case 9:
          return 'сент.';
        case 10:
          return 'окт.';
        case 11:
          return 'нояб.';
        case 12:
          return 'дек.';

        case 1:
        default:
          return 'янв.';
      }
    }
  }

  static String weekday(int day) {
    final modDay = day % 7;
    switch (modDay) {
      case 0:
        return 'Вс';
      case 1:
        return 'Пн';
      case 2:
        return 'Вт';
      case 3:
        return 'Ср';
      case 4:
        return 'Чт';
      case 5:
        return 'Пт';
      case 6:
        return 'Сб';

      default:
        return 'Пн';
    }
  }

  static String pairs(int pairs) {
    final stringPairs = pairs.toString();
    final stringLength = stringPairs.length;
    if (pairs > 5 && pairs < 21) {
      return '$pairs пар';
    } else if (stringPairs[stringLength - 1] == '2' ||
        stringPairs[stringLength - 1] == '3' ||
        stringPairs[stringLength - 1] == '4') {
      return '$pairs пары';
    } else if (stringPairs[stringLength - 1] == '1') {
      return '$pairs пара';
    } else {
      return '$pairs пар';
    }
  }

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

extension StringExtension on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}
