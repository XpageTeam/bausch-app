// ignore_for_file: avoid_annotating_with_dynamic

import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/exceptions/success_false.dart';
import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/models/stories/story_model.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'stories_state.dart';

class StoriesCubit extends Cubit<StoriesState> {
  StoriesCubit() : super(StoriesInitial()) {
    loadData();
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    emit(StoriesLoading());
    final rh = RequestHandler();

    try {
      final parsedData = BaseResponseRepository.fromMap(
        (await rh.get<Map<String, dynamic>>('/stories/')).data!,
      );

      debugPrint(parsedData.data.toString());

      emit(
        StoriesSuccess(
          stories: (parsedData.data as List<dynamic>).map((dynamic e) {
            final model = StoryModel.fromMap(e as Map<String, dynamic>);

            if (prefs.containsKey('story[${model.id}]')) {
              if (prefs.getInt('story[${model.id}]')! <= model.views) {
                return model;
              }
            } else {
              return model;
            }
          }).toList(),
        ),
      );
    } on ResponseParseException catch (e) {
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
    } on SuccessFalse catch (e) {
      emit(
        StoriesFailed(
          title: 'Ошибка при обработке запроса',
          subtitle: e.toString(),
        ),
      );
    }
  }
}
