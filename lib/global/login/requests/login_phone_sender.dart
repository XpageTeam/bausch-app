import 'package:bausch/global/login/models/auth_response_model.dart';
import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:dio/dio.dart';

class PhoneSender {
  static Future<AuthResponseModel> send(String phone) async {
    final rh = RequestHandler();

    final res = BaseResponseRepository.fromMap(
      (await rh.post<Map<String, dynamic>>(
        '/user/authentication/',
        data: FormData.fromMap(
          <String, dynamic>{
            'phone': phone,
          },
        ),
      ))
          .data!,
    );

    return AuthResponseModel.fromJson(res.data as Map<String, dynamic>);
  }

  static Future<BaseResponseRepository> resendSMS(String phone) async {
    final rh = RequestHandler();

    return BaseResponseRepository.fromMap(
      (await rh.post<Map<String, dynamic>>(
        '/user/authentication/resend/',
      ))
          .data!,
    );
  }
}
