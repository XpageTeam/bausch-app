import 'package:bausch/models/faq/question_model.dart';
import 'package:bausch/models/faq/topic_model.dart';
import 'package:bausch/sections/faq/contact_support/forms_listener.dart';
import 'package:bausch/sections/faq/contact_support/forms_provider.dart';
import 'package:bausch/sections/faq/contact_support/forms_screen.dart';
import 'package:flutter/material.dart';

class ContactSupportScreenArguments {
  final QuestionModel? question;
  final TopicModel? topic;

  ContactSupportScreenArguments({
    this.question,
    this.topic,
  });
}

class ContactSupportScreen extends StatelessWidget
    implements ContactSupportScreenArguments {
  final ScrollController controller;
  @override
  final QuestionModel? question;
  @override
  final TopicModel? topic;

  const ContactSupportScreen({
    required this.controller,
    this.question,
    this.topic,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('topic: $topic, question: $question');

    return FormsScreen(
      controller: controller,
      topic: topic,
      question: question,
      // fields: fields,
    );
  }
}
