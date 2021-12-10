import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/exceptions/success_false.dart';
import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

part 'rules_state.dart';

class RulesCubit extends Cubit<RulesState> {
  RulesCubit() : super(RulesInitial());

  Future<void> loadData() async {
    emit(RulesLoading());

    final rh = RequestHandler();

    try {
      final parsedData = BaseResponseRepository.fromMap(
        (await rh.get<Map<String, dynamic>>('static/rules/')).data!,
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
          title: 'Что-то пошло не так',
          subtitle: e.toString(),
        ),
      );
    }
  }
}
