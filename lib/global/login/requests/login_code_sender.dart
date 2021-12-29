import 'package:bausch/global/login/models/code_response_model.dart';
import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:dio/dio.dart';

class CodeSender {
  static Future<CodeResponseModel> send({
    required String code,
    required bool isMobilePhoneConfirmed,
  }) async {
    final rh = RequestHandler();

    final res =
        BaseResponseRepository.fromMap((await rh.post<Map<String, dynamic>>(
      '/user/authentication/code/',
      data: FormData.fromMap(
        <String, dynamic>{
          'code': code,
          'isMobilePhoneConfirmed': isMobilePhoneConfirmed,
        },
      ),
    ))
            .data!);

    return CodeResponseModel.fromJson(res.data as Map<String, dynamic>);
  }
}
