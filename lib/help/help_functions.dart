import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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

  static Future<void> launchURL(String _url) async {
    if (!await launch(_url)) throw 'Could not launch $_url';
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
    final res =
        '${cleanPhone.substring(0, 1) == '7' ? '+' : ''}${cleanPhone.substring(0, 1)} ${cleanPhone.substring(1, 4)} ${cleanPhone.substring(4, 7)}-${cleanPhone.substring(7, 9)}-${cleanPhone.substring(9)}';

    return res;
  }
}

extension NumberPartition on int {
  String get formatString => HelpFunctions.partitionNumber(this);
}
