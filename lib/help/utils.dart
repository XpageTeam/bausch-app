import 'package:bausch/widgets/123/default_notification.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  static Future<bool> tryLaunchUrl({
    required String rawUrl,
    required bool isPhone,
  }) async {
    final url = '${isPhone ? 'tel:' : ''}$rawUrl';

    if (await canLaunch(url)) {
      return launch(url);
    } else {
      return Future<bool>.error(
        'Не удалось перейти по ссылке $url',
      );
    }
  }

  static Future<void> tryShare({
    String? text,
  }) async {
    if (text != null) {
      await Share.share(text);
    } else {
      showDefaultNotification(
        title: 'Не пришла ссылка для того, чтобы поделиться',
      );
    }
  }

  static void copyStringToClipboard(
    String data, {
    String notificationText = 'Скопировано!',
  }) {
    Clipboard.setData(ClipboardData(text: data));
    showDefaultNotification(
      title: notificationText,
      success: true,
    );
  }
}
