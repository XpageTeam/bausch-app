// ignore_for_file: prefer_for_elements_to_map_fromiterable, avoid_annotating_with_dynamic

import 'dart:async';

import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/exceptions/success_false.dart';
import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/models/add_points/quiz/quiz_answer_model.dart';
import 'package:bausch/models/add_points/quiz/quiz_model.dart';
import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:bausch/repositories/user/user_writer.dart';
import 'package:bausch/sections/sheets/screens/add_points/final_add_points.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/widgets/123/default_notification.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class QuizScreenWM extends WidgetModel {
  final BuildContext context;
  final QuizModel quizModel;
  final textEditingController = TextEditingController();

  final loadingState = StreamedState<bool>(false);
  final page = StreamedState<int>(0);
  final selected = StreamedState<int>(0);

  final buttonAction = VoidAction();
  List<QuizAnswerModel> answers = [];

  late UserWM userWm;

  QuizScreenWM({
    required this.context,
    required this.quizModel,
  }) : super(const WidgetModelDependencies());

  @override
  void onBind() {
    buttonAction.bind((_) {
      if (page.value <= quizModel.content.length - 1) {
        //* Добавление выбранного варианта
        answers.add(
          QuizAnswerModel(
            id: quizModel.content[page.value].id,
            title: quizModel.content[page.value].answers[selected.value].id,
          ),
        );

        //* Если что-то введено в текстовое поле
        if (textEditingController.text.isNotEmpty) {
          answers.add(
            QuizAnswerModel(
              id: quizModel.content[page.value].other!.id,
              title: textEditingController.text,
            ),
          );
        }

        //* Обнуление текстового поля
        textEditingController.text = '';
      }
      if (page.value < quizModel.content.length - 1) {
        //* Следующий вопрос
        selected.accept(0);
        page.accept(page.value + 1);
      } else {
        _getPoints();
      }
    });
    super.onBind();
  }

  @override
  void onLoad() {
    userWm = Provider.of<UserWM>(
      context,
      listen: false,
    );
    super.onLoad();
  }

  Future<void> _getPoints() async {
    unawaited(loadingState.accept(true));

    CustomException? error;

    try {
      await QuizSaver.save(
        answers,
      );

      final userRepository = await UserWriter.checkUserToken();
      if (userRepository == null) return;

      await userWm.userData.content(userRepository);
    } on DioError catch (e) {
      error = CustomException(
        title: 'При отправке запроса произошла ошибка',
        subtitle: e.message,
        ex: e,
      );
    } on ResponseParseException catch (e) {
      error = CustomException(
        title: 'При чтении ответа от сервера произошла ошибка',
        subtitle: e.toString(),
        ex: e,
      );
    } on SuccessFalse catch (e) {
      error = CustomException(
        title: e.toString(),
        ex: e,
      );
    }

    unawaited(loadingState.accept(false));

    if (error != null) {
      showDefaultNotification(title: error.title);
    } else {
      await Keys.bottomNav.currentState!.pushNamedAndRemoveUntil(
        '/final_addpoints',
        (route) => route.isCurrent,
        arguments: FinalAddPointsArguments(
          points: quizModel.reward,
        ),
      );
    }
  }
}

class QuizSaver {
  static Future<BaseResponseRepository> save(
    List<QuizAnswerModel> answers,
  ) async {
    final rh = RequestHandler();
    final resp = await rh.post<Map<String, dynamic>>(
      '/review/survey/save/',
      data: FormData.fromMap(
        Map<String, dynamic>.fromIterable(
          answers,
          key: (dynamic e) => (e as QuizAnswerModel).id,
          value: (dynamic e) => (e as QuizAnswerModel).title,
        ),
      ),
      options: rh.cacheOptions
          ?.copyWith(
            maxStale: const Duration(days: 1),
            policy: CachePolicy.request,
          )
          .toOptions(),
    );

    final data = resp.data!;

    return BaseResponseRepository.fromMap(data);
  }
}
