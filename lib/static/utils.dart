
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
}
