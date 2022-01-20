import 'dart:async';

import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/exceptions/success_false.dart';
import 'package:bausch/models/faq/forms/field_model.dart';
import 'package:bausch/models/faq/forms/value_model.dart';
import 'package:bausch/models/faq/question_model.dart';
import 'package:bausch/models/faq/topic_model.dart';
import 'package:bausch/sections/faq/contact_support/downloader/forms_content_downloader.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class FormScreenWM extends WidgetModel {
  final BuildContext context;

  final QuestionModel? question;
  final TopicModel? topic;

  final selectedTopic = StreamedState<ValueModel?>(null);
  final selectedQuestion = StreamedState<ValueModel?>(null);

  final allDataLoadingState = EntityStreamedState<bool>();

  final defaultFieldsList =
      EntityStreamedState<List<FieldModel>>(const EntityState(data: []));
  final extraFieldsList =
      EntityStreamedState<List<FieldModel>>(const EntityState(data: []));

  final topicsList = EntityStreamedState<List<ValueModel>>();
  final questionsList =
      EntityStreamedState<List<ValueModel>>(const EntityState(data: []));

  final _downloader = FormsContentDownloader();

  FormScreenWM({
    required this.context,
    this.question,
    this.topic,
  }) : super(const WidgetModelDependencies());

  @override
  void onLoad() {
    super.onLoad();

    _loadDefaultFields();
    _loadCategoryList();

    if (topic != null) {
      selectedTopic.accept(
        ValueModel(
          id: topic!.id,
          name: topic!.title,
        ),
      );
      loadQuestionsList(topic!.id);
    }

    if (question != null) {
      selectedQuestion.accept(
        ValueModel(
          id: question!.id,
          name: question!.title,
        ),
      );
      loadExtraFields(question!.id);
    }
  }

  //* Получение списка категорий
  Future<void> _loadCategoryList() async {
    if (topicsList.value.isLoading) return;

    unawaited(topicsList.loading());

    try {
      await topicsList.content(await _downloader.loadCategoryList());
    } on DioError catch (e) {
      await topicsList.error(CustomException(
        title: 'При загрузке стандартных полей произошла ошибка',
        subtitle: e.message,
        ex: e,
      ));
    } on ResponseParseException catch (e) {
      await topicsList.error(CustomException(
        title: 'При обработке ответа от сервера произошла ошибка',
        subtitle: e.toString(),
        ex: e,
      ));
    } on SuccessFalse catch (e) {
      await topicsList.error(CustomException(
        title: e.toString(),
        ex: e,
      ));
    }
  }

  //* Получение списка вопросов
  Future<void> loadQuestionsList(int topic) async {
    if (questionsList.value.isLoading) return;

    unawaited(questionsList.loading());

    try {
      await questionsList.content(await _downloader.loadQuestionsList(topic));
    } on DioError catch (e) {
      await questionsList.error(CustomException(
        title: 'При загрузке стандартных полей произошла ошибка',
        subtitle: e.message,
        ex: e,
      ));
    } on ResponseParseException catch (e) {
      await questionsList.error(CustomException(
        title: 'При обработке ответа от сервера произошла ошибка',
        subtitle: e.toString(),
        ex: e,
      ));
    } on SuccessFalse catch (e) {
      await questionsList.error(CustomException(
        title: e.toString(),
        ex: e,
      ));
    }
  }

  //* Получение стандартных полей
  Future<void> _loadDefaultFields() async {
    if (defaultFieldsList.value.isLoading) return;

    unawaited(defaultFieldsList.loading());

    try {
      await defaultFieldsList.content(await _downloader.loadDefaultFields());
    } on DioError catch (e) {
      await defaultFieldsList.error(CustomException(
        title: 'При загрузке стандартных полей произошла ошибка',
        subtitle: e.message,
        ex: e,
      ));
    } on ResponseParseException catch (e) {
      await defaultFieldsList.error(CustomException(
        title: 'При обработке ответа от сервера произошла ошибка',
        subtitle: e.toString(),
        ex: e,
      ));
    } on SuccessFalse catch (e) {
      await defaultFieldsList.error(CustomException(
        title: e.toString(),
        ex: e,
      ));
    }
  }

  //* Получение дополнительных полей
  Future<void> loadExtraFields(int question) async {
    if (extraFieldsList.value.isLoading) return;

    unawaited(extraFieldsList.loading());

    try {
      await extraFieldsList
          .content(await _downloader.loadExtraFields(question));
      debugPrint(extraFieldsList.value.data.toString());
    } on DioError catch (e) {
      await extraFieldsList.error(CustomException(
        title: 'При загрузке стандартных полей произошла ошибка',
        subtitle: e.message,
        ex: e,
      ));
    } on ResponseParseException catch (e) {
      await extraFieldsList.error(CustomException(
        title: 'При обработке ответа от сервера произошла ошибка',
        subtitle: e.toString(),
        ex: e,
      ));
    } on SuccessFalse catch (e) {
      await extraFieldsList.error(CustomException(
        title: e.toString(),
        ex: e,
      ));
    }
  }
}
