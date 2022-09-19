import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/models/my_lenses/lens_product_list_model.dart';
import 'package:bausch/models/my_lenses/lenses_history_list_model.dart';
import 'package:bausch/models/my_lenses/lenses_pair_dates_model.dart';
import 'package:bausch/models/my_lenses/lenses_pair_model.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:dio/dio.dart';

class MyLensesRequester {
  final _rh = RequestHandler();

  // Загружает текущие настройки линз
  Future<LensesPairModel> loadChosenLensesInfo() async {
    final parsedData = BaseResponseRepository.fromMap(
      (await _rh.get<Map<String, dynamic>>(
        '/lenses/current/',
      ))
          .data!,
    );
    try {
      return LensesPairModel.fromMap(
        // ignore: avoid_dynamic_calls
        parsedData.data as Map<String, dynamic>,
      );
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      throw ResponseParseException('Ошибка в loadLensesPair: $e');
    }
  }

  // Загружает даты пары линз
  Future<LensesPairDatesModel> loadLensesDates() async {
    final parsedData = BaseResponseRepository.fromMap(
      (await _rh.get<Map<String, dynamic>>(
        '/lenses/worn/',
      ))
          .data!,
    );
    try {
      return LensesPairDatesModel.fromMap(
        // ignore: avoid_dynamic_calls
        parsedData.data as Map<String, dynamic>,
      );
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      throw ResponseParseException('Ошибка в LensesPairDatesModel: $e');
    }
  }

// TODO(info): бэк не готов
  // Загружает историю ношения линз
  Future<LensesHistoryListModel> loadLensesHistory() async {
    final parsedData = BaseResponseRepository.fromMap(
      (await _rh.get<Map<String, dynamic>>(
        '/lenses/history/',
      ))
          .data!,
    );
    try {
      return LensesHistoryListModel.fromMap(parsedData.data as List<dynamic>);
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      throw ResponseParseException('Ошибка в loadLensesHistory: $e');
    }
  }

// TODO(info): бэк не готов
  // заканчиваем пару линз
  Future<BaseResponseRepository> endLensesPair({
    required bool left,
    required bool right,
    required int pairId,
  }) async {
    try {
      final result = await _rh.post<Map<String, dynamic>>(
        '/lenses/:$pairId/finish/',
        data: FormData.fromMap(<String, dynamic>{
          'left': left,
          'right': right,
        }),
      );
      final response =
          BaseResponseRepository.fromMap(result.data as Map<String, dynamic>);
      return response;
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      throw ResponseParseException('Ошибка в endLensesPair: $e');
    }
  }

  // надеваем пару линз
  Future<BaseResponseRepository> putOnLensesPair({
    required DateTime? leftDate,
    required DateTime? rightDate,
  }) async {
    try {
      final result = await _rh.post<Map<String, dynamic>>(
        '/lenses/put-on/',
        data: FormData.fromMap(<String, dynamic>{
          'left[date]': leftDate?.toIso8601String(),
          'right[date]': rightDate?.toIso8601String(),
        }),
      );
      final response =
          BaseResponseRepository.fromMap(result.data as Map<String, dynamic>);
      return response;
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      throw ResponseParseException('Ошибка в putOnLensesPair: $e');
    }
  }

  // обновление расписания уведомлений
  Future<BaseResponseRepository> updateReminders({
    required List<int> reminders,
  }) async {
    try {
      final result = await _rh.post<Map<String, dynamic>>(
        '/lenses/reminders/',
        data: FormData.fromMap(<String, dynamic>{
          'values[]': reminders,
        }),
      );
      final response =
          BaseResponseRepository.fromMap(result.data as Map<String, dynamic>);
      return response;
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      throw ResponseParseException('Ошибка в updateReminders: $e');
    }
  }

  // список упаковок линз
  Future<LensProductModel> loadLensProduct({required int id}) async {
    final parsedData = BaseResponseRepository.fromMap(
      (await _rh.get<Map<String, dynamic>>(
        '/lenses/product/$id',
      ))
          .data!,
    );
    try {
      return LensProductModel.fromMap(parsedData.data as Map<String, dynamic>);
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      throw ResponseParseException('Ошибка в loadLensProduct: $e');
    }
  }
}
