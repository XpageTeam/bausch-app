import 'package:bausch/models/faq/question_model.dart';
import 'package:bausch/models/faq/topic_model.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class FormScreenWM extends WidgetModel {
  final QuestionModel? question;
  final TopicModel? topic;

  final BuildContext context;

  FormScreenWM({
    required this.context,
    this.question,
    this.topic,
    List<QuestionField>? fields,

  }) : super(const WidgetModelDependencies());
}
