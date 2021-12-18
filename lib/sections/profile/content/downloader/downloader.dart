// ignore_for_file: avoid_catches_without_on_clauses, avoid_annotating_with_dynamic

import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:bausch/sections/profile/content/models/base_order_model.dart';
import 'package:bausch/sections/profile/content/models/webinar_model.dart';

class ProfileContentDownloader {
  final _rh = RequestHandler();

  /// Загружает историю заказов
  // TODO(Danil): избавиться от null
  Future<List<BaseOrderModel?>> loadOrderHistory() async {
    final result =
        BaseResponseRepository.fromMap((await _rh.get<Map<String, dynamic>>(
      '/user/order/history/',
    ))
            .data!);

    try {
      return (result.data as List<dynamic>?)
              ?.map<BaseOrderModel?>((dynamic item) {
            item as Map<String, dynamic>;

            if (item['category'] == 'webinar') {
              return WebinarOrderModel.fromMap(item);
            }

            return null;
          }).toList() ??
          [];
    } on ResponseParseException {
      rethrow;
    } catch (e) {
      throw ResponseParseException(e.toString());
    }
  }
}
