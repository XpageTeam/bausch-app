import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/models/my_lenses/lens_product_list_model.dart';
import 'package:bausch/models/my_lenses/lenses_pair_dates_model.dart';
import 'package:bausch/models/my_lenses/lenses_pair_model.dart';
import 'package:bausch/models/my_lenses/lenses_product_history_list_model.dart';
import 'package:bausch/models/my_lenses/lenses_worn_history_list_model.dart';
import 'package:bausch/models/my_lenses/recommended_products_list_modul.dart';
import 'package:bausch/models/my_lenses/reminders_buy_model.dart';
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

  // Загружает историю ношения линз
  Future<LensesWornHistoryListModel> loadLensesWornHistory({
    required bool showAll,
  }) async {
    final parsedData = BaseResponseRepository.fromMap(
      (await _rh.get<Map<String, dynamic>>(
        '/lenses/worn/history/?showAll=$showAll',
      ))
          .data!,
    );
    try {
      return LensesWornHistoryListModel.fromMap(
        parsedData.data as List<dynamic>,
      );
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      throw ResponseParseException('Ошибка в loadLensesWornHistory: $e');
    }
  }

  // Загружает историю использованных продуктов
  Future<LensesProductHistoryListModel> loadLensesProductHistory() async {
    final parsedData = BaseResponseRepository.fromMap(
      (await _rh.get<Map<String, dynamic>>(
        '/lenses/product/history/',
      ))
          .data!,
    );
    try {
      return LensesProductHistoryListModel.fromMap(
        parsedData.data as List<dynamic>,
      );
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      throw ResponseParseException('Ошибка в loadLensesHistory: $e');
    }
  }

  // Загружает установленные напоминания
  Future<List<dynamic>> loadLensesReminders() async {
    final parsedData = BaseResponseRepository.fromMap(
      (await _rh.get<Map<String, dynamic>>(
        '/lenses/reminders/',
      ))
          .data!,
    );
    try {
      return parsedData.data as List<dynamic>;
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      throw ResponseParseException('Ошибка в loadLensesReminders: $e');
    }
  }

  // Загружает установленное напоминание о покупке
  Future<RemindersBuyModel> loadLensesRemindersBuy() async {
    final parsedData = BaseResponseRepository.fromMap(
      (await _rh.get<Map<String, dynamic>>(
        '/lenses/reminders-buy/',
      ))
          .data!,
    );
    try {
      return RemindersBuyModel.fromMap(
        // ignore: avoid_dynamic_calls
        parsedData.data as Map<String, dynamic>,
      );
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      throw ResponseParseException('Ошибка в loadLensesReminders: $e');
    }
  }

  // подключаем напоминания о покупке
  Future<BaseResponseRepository> setDefaultRemindersBuy() async {
    try {
      final result = await _rh.post<Map<String, dynamic>>(
        '/lenses/reminders-buy/default/',
      );
      final response =
          BaseResponseRepository.fromMap(result.data as Map<String, dynamic>);
      return response;
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      throw ResponseParseException('Ошибка в setDefaultRemindersBuy: $e');
    }
  }

  // изменяем напоминания о покупке
  Future<BaseResponseRepository> updateRemindersBuy({
    required String date,
    required String replay,
    required List<String> reminders,
  }) async {
    try {
      final result = await _rh.post<Map<String, dynamic>>(
        '/lenses/reminders-buy/',
        data: FormData.fromMap(<String, dynamic>{
          'date': date,
          'replay': replay,
          'reminders[]': reminders,
        }),
      );
      final response =
          BaseResponseRepository.fromMap(result.data as Map<String, dynamic>);
      return response;
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      throw ResponseParseException('Ошибка в updateRemindersBuy: $e');
    }
  }

  // рекомендуемые продукты
  Future<RecommendedProductsListModel> loadRecommendedProducts({
    required int? productId,
  }) async {
    final parsedData = BaseResponseRepository.fromMap(
      (await _rh.get<Map<String, dynamic>>(
        '/lenses/recommended-products/?productId=$productId',
      ))
          .data!,
    );
    try {
      return RecommendedProductsListModel.fromMap(
        parsedData.data as List<dynamic>,
      );
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      throw ResponseParseException('Ошибка в loadRecommendedProducts: $e');
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
    required List<String> reminders,
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

  // удаление однодневных напоминаний
  Future<BaseResponseRepository> deleteRemindersBuy() async {
    try {
      final result = await _rh.post<Map<String, dynamic>>(
        '/lenses/reminders-buy/delete/',
      );
      final response =
          BaseResponseRepository.fromMap(result.data as Map<String, dynamic>);
      return response;
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      throw ResponseParseException('Ошибка в deleteRemindersBuy: $e');
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
