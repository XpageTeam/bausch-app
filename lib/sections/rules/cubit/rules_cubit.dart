import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/exceptions/success_false.dart';
import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

part 'rules_state.dart';

enum RulesOrLinks { rules, links }

///Используется для получения правил, а также для получения библиотеки ссылок, т.к. запросы идентичные
class RulesCubit extends Cubit<RulesState> {
  RulesCubit() : super(RulesInitial());

  Future<void> loadData(RulesOrLinks type) async {
    emit(RulesLoading());

    final rh = RequestHandler();

    //* Выбор ссылки в зависимости от типа
    final link =
        type == RulesOrLinks.rules ? '/static/rules/' : '/static/library/';

    try {
      final parsedData = BaseResponseRepository.fromMap(
        (await rh.get<Map<String, dynamic>>(link)).data!,
      );

      emit(RulesSuccess(data: parsedData.data as String));
    } on ResponseParseException catch (e) {
      emit(
        RulesFailed(
          title: 'Ошибка при обработке ответа от сервера',
          subtitle: e.toString(),
        ),
      );
    } on DioError catch (e) {
      emit(
        RulesFailed(
          title: 'Ошибка при отправке запроса',
          subtitle: e.toString(),
        ),
      );
    } on SuccessFalse catch (e) {
      emit(
        RulesFailed(
          title: 'Ошибка при отправке запроса',
          subtitle: e.toString(),
        ),
      );
    }
  }
}
