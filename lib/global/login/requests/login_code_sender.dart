import 'dart:convert';
import 'dart:io';

import 'package:bausch/global/login/models/code_response_model.dart';
import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';

class CodeSender {
  static Future<CodeResponseModel> send({
    required String code,
    required bool isMobilePhoneConfirmed,
  }) async {
    final rh = RequestHandler();

    final deviceInfo = DeviceInfoPlugin();

    final res = BaseResponseRepository.fromMap(
      (await rh.post<Map<String, dynamic>>(
        '/user/authentication/code/',
        data: json.encode({
          'code': code,
          'isMobilePhoneConfirmed': isMobilePhoneConfirmed,
          'device_id': Platform.isAndroid
              ? (await deviceInfo.androidInfo).androidId
              : Platform.isIOS
                  ? (await deviceInfo.iosInfo).identifierForVendor
                  : Platform.isMacOS
                      ? (await deviceInfo.macOsInfo).systemGUID
                      : 'unknown',
        }),
      ))
          .data!,
    );

    return CodeResponseModel.fromJson(res.data as Map<String, dynamic>);
  }
}
