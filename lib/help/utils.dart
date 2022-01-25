import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/widgets/123/default_notification.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  static Future<void> tryLaunchUrl({
    required String rawUrl,
    bool isPhone = false,
    void Function(CustomException ex)? onError,
  }) async {
    final uri = Uri(scheme: isPhone ? 'tel' : '', path: rawUrl);
    final uriString = uri.toString();

    if (await canLaunch(uriString)) {
      await launch(uriString);
    } else {
      onError?.call(
        CustomException(title: 'Не удалось перейти по ссылке $rawUrl'),
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
