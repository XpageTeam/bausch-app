import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/models/stories/story_model.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

part 'stories_state.dart';

class StoriesCubit extends Cubit<StoriesState> {
  StoriesCubit() : super(StoriesInitial()) {
    loadData();
  }

  Future<void> loadData() async {
    emit(StoriesLoading());
    final rh = RequestHandler();

    try {
      final parsedData = BaseResponseRepository.fromMap(
        (await rh.get<Map<String, dynamic>>('stories')).data!,
      );

      if (parsedData.success) {
        emit(
          StoriesSuccess(
            stories: (parsedData.data as List<dynamic>)
                .map((dynamic e) =>
                    StoryModel.fromMap(e as Map<String, dynamic>))
                .toList(),
          ),
        );
      } else {
        emit(StoriesFailed(title: 'title'));
      }
    } on ResponseParseExeption catch (e) {
      emit(
        StoriesFailed(
          title: 'Ошибка при обработке ответа от сервера',
          subtitle: e.toString(),
        ),
      );
    } on DioError catch (e) {
      emit(
        StoriesFailed(
          title: 'Ошибка при отправке запроса',
          subtitle: e.toString(),
        ),
      );
    }
  }
}
