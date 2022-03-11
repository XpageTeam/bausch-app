import 'dart:convert';

import 'package:bausch/global/login/models/code_response_model.dart';
import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';

class CodeSender {
  static Future<CodeResponseModel> send({
    required String code,
    required bool isMobilePhoneConfirmed,
    required String uuid,
  }) async {
    final rh = RequestHandler();


    await Future<void>.delayed(const Duration(seconds: 2));

    final res = BaseResponseRepository.fromMap(
        (await rh.post<Map<String, dynamic>>(
          '/user/authentication/code/',
          data: json.encode({
            'code': code,
            'isMobilePhoneConfirmed': isMobilePhoneConfirmed,
            'device_id': uuid,
          }),
        ))
            .data!,
      );


    return CodeResponseModel.fromJson(res.data as Map<String, dynamic>);
  }
}
