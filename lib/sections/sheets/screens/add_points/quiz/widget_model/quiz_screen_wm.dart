// ignore_for_file: prefer_for_elements_to_map_fromiterable, avoid_annotating_with_dynamic

import 'dart:async';
import 'dart:convert';

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
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/widgets/123/default_notification.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class QuizScreenWM extends WidgetModel {
  final BuildContext context;
  final QuizModel quizModel;

  final keyForOffset = GlobalKey();

  final textEditingController = TextEditingController();

  final canMoveToNextPage = StreamedState<bool>(false);

  final colorState = StreamedState<Color>(AppTheme.mystic);

  late final UserWM userWm;
  late final FocusNode focusNode;

  final loadingState = StreamedState<bool>(false);
  late final contentStreamed = StreamedState<QuizContentModel>(
    quizModel.content[currentPage],
  );
  final selectedIndexes = StreamedState<List<int>>([]);

  final buttonAction = VoidAction();
  final addToAnswersAction = StreamedAction<int>();

  Map<String, List<QuizAnswerModel>> mapAnswers =
      <String, List<QuizAnswerModel>>{};

  int currentPage = 0;

  String get progressText => '${currentPage + 1}/${quizModel.content.length}';

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

    focusNode = FocusNode();

    super.onLoad();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  void onBind() {
    buttonAction.bind((_) {
      _writeAnswers();

      if (currentPage == quizModel.content.length - 1) {
        _finishQuiz();
      } else {
        _moveToNexPage();
      }
    });

    addToAnswersAction.bind((index) {
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

      if (index == contentStreamed.value.answers.length - 1) {
        FocusScope.of(context).requestFocus(focusNode);
      }

      _chekMoveNextPage();
    });

    _chekMoveNextPage();

    focusNode.addListener(() {
      if (focusNode.hasFocus){
        setFocus();
      }
    });

    super.onBind();
  }

  void setFocus() {
    final targetIndex = contentStreamed.value.answers.length - 1;

    if (!selectedIndexes.value.contains(targetIndex)) {
      addToAnswersAction(targetIndex);
    }
  }

  void _writeAnswers() {
    //* Добавление выбранных вариантов
    final questionId = quizModel.content[currentPage].id;
    final selectedAnswers = _getSelectedAnswers();

    if (selectedAnswers.isNotEmpty) {
      mapAnswers.update(
        questionId,
        (value) => value..addAll(selectedAnswers),
        ifAbsent: () => selectedAnswers,
      );
    }

    //* Если что-то введено в текстовое поле
    if (textEditingController.text.isNotEmpty) {
      final messageAnswer = QuizAnswerModel(
        id: quizModel.content[currentPage].other!.id,
        title: textEditingController.text,
        type: 'message',
      );

      mapAnswers.addAll(
        <String, List<QuizAnswerModel>>{
          quizModel.content[currentPage].other!.id: [messageAnswer],
        },
      );
    }

    _chekMoveNextPage();
  }

  void _moveToNexPage() {
    currentPage++;

    final newContent = quizModel.content[currentPage];

    //* Обнуление текстового поля
    textEditingController.text = '';
    focusNode.unfocus();

    contentStreamed.accept(newContent);
    selectedIndexes.accept([]);

    if (keyForOffset.currentContext != null) {
      Scrollable.ensureVisible(keyForOffset.currentContext!);
    }

    _chekMoveNextPage();
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

  Future<void> _finishQuiz() async {
    unawaited(loadingState.accept(true));

    CustomException? error;

    try {
      await QuizSaver.save(
        mapAnswers,
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

  void _chekMoveNextPage() {
    final isNotRequired = !quizModel.content[currentPage].isRequired;

    if (isNotRequired) {
      canMoveToNextPage.accept(true);
      return;
    }

    if (selectedIndexes.value.isNotEmpty) {
      canMoveToNextPage.accept(true);
    } else {
      canMoveToNextPage.accept(false);
    }
  }
}

class QuizSaver {
  static Future<BaseResponseRepository> save(
    Map<String, List<QuizAnswerModel>> answers,
  ) async {
    final rh = RequestHandler();
    final formData = _convertAnswers(answers);

    final resp = await rh.post<Map<String, dynamic>>(
      '/review/survey/save/',
      data: FormData.fromMap(
        formData,
      ),
    );

    final data = resp.data!;

    return BaseResponseRepository.fromMap(data);
  }

  static Map<String, String> _convertAnswers(
    Map<String, List<QuizAnswerModel>> answers,
  ) {
    return answers.entries.fold<Map<String, String>>(
      <String, String>{},
      (globalMap, element) {
        final key = element.key;
        final value = element.value;

        return globalMap
          ..addAll(<String, String>{
            key: value.first.type == 'checkbox'
                ? json.encode(value.map((e) => e.id).toList())
                : value.first.type == 'radio'
                    ? value.first.id
                    : value.first.title,
          });
      },
    );
  }
}
