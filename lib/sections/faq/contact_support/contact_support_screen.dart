import 'package:bausch/models/faq/question_model.dart';
import 'package:bausch/models/faq/topic_model.dart';
import 'package:bausch/sections/faq/contact_support/screens/forms_screen.dart';
import 'package:flutter/material.dart';

class ContactSupportScreenArguments {
  final QuestionModel? question;
  final TopicModel? topic;
  final int? orderID;

  ContactSupportScreenArguments({
    this.question,
    this.topic,
    this.orderID,
  });
}

class ContactSupportScreen extends StatelessWidget
    implements ContactSupportScreenArguments {
  final ScrollController controller;
  @override
  final QuestionModel? question;
  @override
  final TopicModel? topic;

  @override
  final int? orderID;

  const ContactSupportScreen({
    required this.controller,
    this.question,
    this.topic,
    this.orderID,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormsScreen(
      controller: controller,
      topic: topic,
      question: question,
      // fields: fields,
    );
  }
}
