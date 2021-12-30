import 'package:bausch/widgets/123/default_notification.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  static Future<bool> tryLaunchUrl({
    required String rawUrl,
    required bool isPhone,
  }) async {
    final url = '${isPhone ? 'tel' : 'https'}:$rawUrl';

    if (await canLaunch(url)) {
      return launch(
        url,
      );
    } else {
      return Future<bool>.error(
        'Could not launch $url',
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
