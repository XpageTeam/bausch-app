// ignore_for_file: prefer_for_elements_to_map_fromiterable, avoid_annotating_with_dynamic

import 'dart:async';

import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/exceptions/success_false.dart';
import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/models/add_points/quiz/quiz_answer_model.dart';
import 'package:bausch/models/add_points/quiz/quiz_content_model.dart';
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

  late final contentStreamed = StreamedState<QuizContentModel>(
    quizModel.content[currentPage],
  );

  final selectedIndexes = StreamedState<List<int>>([]);

  final buttonAction = VoidAction();
  final addToAnswerAction = StreamedAction<int>();

  List<QuizAnswerModel> answers = [];

  int currentPage = 0;

  late UserWM userWm;

  String get progressText => '${currentPage + 1}/${quizModel.content.length}';

  bool get canMoveNextPage {
    final isNotRequired = !quizModel.content[currentPage].isRequired;

    if (isNotRequired) return true;

    if (selectedIndexes.value.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  QuizScreenWM({
    required this.context,
    required this.quizModel,
  }) : super(
          const WidgetModelDependencies(),
        );

  @override
  void onLoad() {
    userWm = Provider.of<UserWM>(
      context,
      listen: false,
    );
    super.onLoad();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  void onBind() {
    buttonAction.bind((_) {
      if (currentPage <= quizModel.content.length - 1) {
        //* Добавление выбранных вариантов
        answers.addAll(_getSelectedAnswers());

        //* Обнуление текстового поля
        textEditingController.text = '';

        //* Если что-то введено в текстовое поле
        if (textEditingController.text.isNotEmpty) {
          answers.add(
            QuizAnswerModel(
              id: quizModel.content[currentPage].other!.id,
              title: textEditingController.text,
            ),
          );
        }
      }

      if (currentPage < quizModel.content.length - 1) {
        //* Следующий вопрос
        _nexPage();
      } else {
        _getPoints();
      }
    });

    addToAnswerAction.bind((index) {
      final currentSelectType = quizModel.content[currentPage].type;

      if (currentSelectType == 'radio') {
        selectedIndexes.accept([index!]);
      } else {
        if (selectedIndexes.value.contains(index)) {
          selectedIndexes.value.remove(index);
        } else {
          selectedIndexes.value.add(index!);
        }
        selectedIndexes.accept(selectedIndexes.value);
      }
    });

    super.onBind();
  }

  void _nexPage() {
    currentPage++;

    final content = quizModel.content[currentPage];

    contentStreamed.accept(content);
    selectedIndexes.accept([]);
  }

  List<QuizAnswerModel> _getSelectedAnswers() {
    final selectedAnswers = quizModel.content[currentPage].answers
        .asMap()
        .entries
        .where(
          (element) =>
              selectedIndexes.value.any((index) => element.key == index),
        )
        .map((e) => e.value)
        .toList();

    return selectedAnswers;
  }

  Future<void> _getPoints() async {
    unawaited(loadingState.accept(true));

    CustomException? error;

    try {
      await QuizSaver.save(
        answers,
      );
      await _updateUserInformation();
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

  Future<void> _updateUserInformation() async {
    final userRepository = await UserWriter.checkUserToken();
    if (userRepository == null) return;

    await userWm.userData.content(userRepository);
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
