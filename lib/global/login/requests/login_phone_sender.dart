import 'package:bausch/global/login/models/auth_response_model.dart';
import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mindbox/mindbox.dart';

class PhoneSender {
  static Future<AuthResponseModel> send(String phone) async {
    final rh = RequestHandler();

    var _uuid = '';

    Mindbox.instance.getDeviceUUID((uuid) async {
      
      _uuid = uuid;
    });



    await Future<void>.delayed(const Duration(seconds: 2));

    final res = BaseResponseRepository.fromMap(
      (await rh.post<Map<String, dynamic>>(
        '/user/authentication/',
        data: FormData.fromMap(
          <String, dynamic>{
            'phone': phone,
            'device_id': _uuid,
          },
        ),
      ))
          .data!,
    );

    debugPrint(_uuid);

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
