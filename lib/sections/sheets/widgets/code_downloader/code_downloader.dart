// ignore_for_file: avoid_catches_without_on_clauses

import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';

class CodeDownloader {
  static late BaseResponseRepository _parsedData;

  //* Делаю два запроса параллельно
  static Future<String> downloadCode(int id) async {
    await waitForTimer();
    await loadData(id);
    if ((_parsedData.data as Map<String, dynamic>)['promocode'] != null) {
      return (_parsedData.data as Map<String, dynamic>)['promocode'] as String;
    } else {
      return 'Промокод будет доступен в истории заказов!';
    }
  }

  //* Таймер
  static Future<void> waitForTimer() async {
    await Future<void>.delayed(const Duration(seconds: 15));
  }

  //* Получаю промокод по id заказа
  static Future<void> loadData(int id) async {
    final _rh = RequestHandler();
    try {
      _parsedData = BaseResponseRepository.fromMap(
        (await _rh.get<Map<String, dynamic>>(
          '/order/$id/promocode/',
        ))
            .data!,
      );
    } catch (e) {
      throw ResponseParseException('CodeDownloader: $e');
    }
  }
}
