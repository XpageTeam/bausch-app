// ignore_for_file: comment_references, avoid_dynamic_calls

import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/models/mappable_object.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:bausch/static/static_data.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository implements MappableInterface<UserRepository> {
  static UserRepository? currentUser;

  final String phone;
  final String email;
  final String? name;

  UserRepository({
    required this.phone,
    required this.email,
    this.name,
  });

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    throw UnimplementedError();
  }

  /// Отправляет запрос на отправку смс-кода
  static Future<BaseResponseRepository> sendPhone(String phone) async {
    final rh = RequestHandler();

    final res = await rh.post<Map<String, dynamic>>(
      '/user/authentication/',
      data: FormData.fromMap(<String, dynamic>{
        'phone': phone,
      }),
    );

    return BaseResponseRepository.fromMap(res.data!);
  }
}
