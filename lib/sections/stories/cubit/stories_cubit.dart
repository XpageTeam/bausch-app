// ignore_for_file: avoid_annotating_with_dynamic

import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/exceptions/success_false.dart';
import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/models/stories/story_model.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'stories_state.dart';

class StoriesCubit extends Cubit<StoriesState> {
  final BuildContext context;
  StoriesCubit({
    required this.context,
  }) : super(StoriesInitial()) {
    loadData();
  }

  Future<void> loadData() async {
    final userWM = Provider.of<UserWM>(context, listen: false);

    final prefs = await SharedPreferences.getInstance();

    emit(StoriesLoading(
      stories:
          state is StoriesSuccess ? (state as StoriesSuccess).stories : null,
    ));

    final rh = RequestHandler();

    try {
      final parsedData = BaseResponseRepository.fromMap(
        (await rh.get<Map<String, dynamic>>('/stories/')).data!,
      );

      emit(
        StoriesSuccess(
          stories: (parsedData.data as List<dynamic>).map((dynamic e) {
            final model = StoryModel.fromMap(e as Map<String, dynamic>);

            if (prefs.containsKey(
              'user[${userWM.userData.value.data?.user.id}]story[${model.id}]',
            )) {
              if (prefs.getInt(
                    'user[${userWM.userData.value.data?.user.id}]story[${model.id}]',
                  )! <=
                  model.views) {
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
          title: e.toString(),
        ),
      );
    }
  }
}
