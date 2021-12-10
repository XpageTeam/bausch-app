import 'package:bausch/models/faq/question_model.dart';
import 'package:bausch/models/faq/topic_model.dart';
import 'package:bausch/sections/faq/contact_support/forms_listener.dart';
import 'package:bausch/sections/faq/contact_support/forms_provider.dart';
import 'package:bausch/sections/faq/contact_support/forms_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ContactSupportScreenArguments {
  final QuestionModel? question;
  final TopicModel? topic;

  ContactSupportScreenArguments({this.question, this.topic});
}

class ContactSupportScreen extends StatefulWidget
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
  State<ContactSupportScreen> createState() => _ContactSupportScreenState();
}

class _ContactSupportScreenState extends State<ContactSupportScreen> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(5),
        topRight: Radius.circular(5),
      ),
      child: FormsProvider(
        child: FormsListener(
          child: FormsScreen(
            controller: widget.controller,
            topic: widget.topic,
            question: widget.question,
          ),
        ),
      ),
    );
  }
}
