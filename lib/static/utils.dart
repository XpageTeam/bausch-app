import 'package:url_launcher/url_launcher.dart';

class Utils {
  static Future<bool> tryLaunchUrl({
    required String rawUrl,
    required bool isPhone,
  }) async {
    bool? forceSafariVC;
    var forceWebView = false;
    var headers = <String, String>{};

    var url = 'tel:$rawUrl';

    if (!isPhone) {
      forceSafariVC = true;
      forceWebView = true;
      headers = <String, String>{'my_header_key': 'my_header_value'};

      url = 'https:$rawUrl';
    }

    if (await canLaunch(url)) {
      return launch(
        url,
        forceSafariVC: forceSafariVC,
        forceWebView: forceWebView,
        headers: headers,
      );
    } else {
      return Future<bool>.error(
        'Could not launch $url',
      );
    }
  }
}
