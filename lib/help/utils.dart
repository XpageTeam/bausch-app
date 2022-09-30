import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/widgets/default_notification.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Utils {
  static Future<bool> launchUrl({
    required String rawUrl,
    required bool isPhone,
  }) async {
    final url = '${isPhone ? 'tel:' : ''}$rawUrl';

    if (await canLaunchUrlString(url)) {
      return launchUrlString(url);
    } else {
      return Future<bool>.error(
        'Не удалось перейти по ссылке $url',
      );
    }
  }

  static Future<void> tryLaunchUrl({
    required String rawUrl,
    bool isPhone = false,
    void Function(CustomException ex)? onError,
  }) async {
    final uriString = '${isPhone ? 'tel:' : ''}$rawUrl';

    if (await canLaunchUrlString(uriString)) {
      await launchUrlString(
        uriString,
      );
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

  static void unfocus(BuildContext context) {
    if (FocusScope.of(context).hasFocus) {
      FocusScope.of(context).unfocus();
    }
  }
}
