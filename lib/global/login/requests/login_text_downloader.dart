import 'package:bausch/global/login/models/login_text.dart';
import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

class LoginTextDownloader {
  static Future<LoginText> load() async {
    final rh = RequestHandler();

    final res = BaseResponseRepository.fromMap(
      (await rh.get<Map<String, dynamic>>(
        '/static/regText/',
        options: rh.cacheOptions
            ?.copyWith(
              maxStale: const Nullable(Duration(days: 2)),
              policy: CachePolicy.request,
            )
            .toOptions(),
      ))
          .data!,
    );

    return LoginText.fromJson(res.data as Map<String, dynamic>);
  }
}
