// ignore_for_file: avoid_annotating_with_dynamic

import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/exceptions/success_false.dart';
import 'package:bausch/models/add_points/add_points_model.dart';
import 'package:bausch/models/add_points/quiz/quiz_model.dart';
import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

part 'add_points_event.dart';
part 'add_points_state.dart';

class AddPointsBloc extends Bloc<AddPointsEvent, AddPointsState> {
  AddPointsBloc() : super(AddPointsInitial()) {
    add(AddPointsGet());
  }

  @override
  Stream<AddPointsState> mapEventToState(
    AddPointsEvent event,
  ) async* {
    if (event is AddPointsGet) {
      yield AddPointsLoading();
      yield await loadData();
    }
  }

  Future<AddPointsState> loadData() async {
    final rh = RequestHandler();

    try {
      final parsedData = BaseResponseRepository.fromMap(
        (await rh.get<Map<String, dynamic>>('/user/points/more/')).data!,
      );

      return AddPointsGetSuccess(
        models: (parsedData.data as List<dynamic>).map((dynamic item) {
          if ((item as Map<String, dynamic>).containsValue('quiz')) {
            return QuizModel.fromMap(item);
          } else {
            return AddPointsModel.fromMap(item);
          }
        }).toList(),
      );
    } on ResponseParseException catch (e) {
      return AddPointsFailed(
        title: 'Ошибка при обработке ответа от сервера',
        subtitle: e.toString(),
      );
    } on DioError catch (e) {
      return AddPointsFailed(
        title: 'Ошибка при отправке запроса',
        subtitle: e.toString(),
      );
    } on SuccessFalse catch (e) {
      return AddPointsFailed(
        title: e.toString(),
      );
    }
  }
}
