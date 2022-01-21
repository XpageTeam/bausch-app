// ignore_for_file: unnecessary_statements

import 'dart:async';

import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/exceptions/success_false.dart';
import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/models/faq/forms/field_model.dart';
import 'package:bausch/models/faq/forms/value_model.dart';
import 'package:bausch/models/faq/question_model.dart';
import 'package:bausch/models/faq/topic_model.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:bausch/sections/faq/contact_support/downloader/forms_content_downloader.dart';
import 'package:bausch/widgets/123/default_notification.dart';
import 'package:dio/dio.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class FormScreenWM extends WidgetModel {
  final BuildContext context;

  late final UserWM userWM;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController =
      MaskedTextController(mask: '+7 000 000 00 00');
  final TextEditingController commentController = TextEditingController();

  final QuestionModel? question;
  final TopicModel? topic;

  final sendAction = VoidAction();

  final loadingState = StreamedState<bool>(false);

  final buttonEnabledState = StreamedState<bool>(false);

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

  final extraList = EntityStreamedState<Map<String, dynamic>>(
    const EntityState(
      data: <String, dynamic>{},
    ),
  );

  final _downloader = FormsContentDownloader();

  FormScreenWM({
    required this.context,
    this.question,
    this.topic,
  }) : super(const WidgetModelDependencies());

  @override
  void onLoad() {
    super.onLoad();

    userWM = Provider.of<UserWM>(context, listen: false);

    extraList.bind((val) {
      debugPrint(val.toString());
      _validate();
    });

    selectedTopic.bind((_) {
      _validate();
    });

    selectedQuestion.bind((_) {
      _validate();
    });

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

    if (userWM.userData.value.data!.user.name != null) {
      nameController.text = userWM.userData.value.data!.user.name!;
    }

    if (userWM.userData.value.data!.user.email != null) {
      emailController.text = userWM.userData.value.data!.user.email!;
    }

    phoneController
      ..text = userWM.userData.value.data!.user.phone
      ..addListener(_validate);
    nameController.addListener(_validate);
    emailController.addListener(_validate);
  }

  @override
  void onBind() {
    sendAction.bind((_) {
      sendData(
        nameController.text,
        emailController.text,
        phoneController.text,
        commentController.text,
        selectedTopic.value?.id ?? 0,
        selectedQuestion.value?.id ?? 0,
      );
    });
    super.onBind();
  }

  //* Отправка полей
  Future<void> sendData(
    String name,
    String email,
    String phone,
    String? comment,
    int topic,
    int question,
  ) async {
    unawaited(loadingState.accept(true));

    final rh = RequestHandler();

    CustomException? error;

    try {
      BaseResponseRepository.fromMap((await rh.post<Map<String, dynamic>>(
        '/faq/form/',
        data: FormData.fromMap(
          <String, dynamic>{
            'fio': name,
            'email': email,
            'phone': phone,
            'comment': comment,
            'topic': topic,
            'question': question,
          }..addAll(extraList.value.data!),
        ),
      ))
          .data!);
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
      showDefaultNotification(
        title: error.title,
        subtitle: error.subtitle,
      );
    } else {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
      showDefaultNotification(
        title: 'Ваше обращение успешно отправлено!',
        success: true,
      );
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
        title: 'При загрузке дополнительных полей произошла ошибка',
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

  void _validate() {
    if (nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        (extraFieldsList.value.data!.length == extraList.value.data!.length) &&
        selectedTopic.value != null &&
        selectedQuestion.value != null) {
      buttonEnabledState.accept(true);
    } else {
      buttonEnabledState.accept(false);
    }
  }
}
