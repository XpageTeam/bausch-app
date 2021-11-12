import 'package:bausch/models/faq/question_model.dart';
import 'package:bausch/models/faq/topic_model.dart';
import 'package:bausch/sections/faq/bloc/forms/fields_bloc.dart';
import 'package:bausch/sections/faq/contact_support/default_forms_section.dart';
import 'package:bausch/sections/faq/contact_support/extra_forms_section.dart';
import 'package:bausch/sections/faq/contact_support/forms_listener.dart';
import 'package:bausch/sections/faq/contact_support/forms_provider.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/buttons/normal_icon_button.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          child: BlocBuilder<FieldsBloc, FieldsState>(
            builder: (context, state) {
              return Scaffold(
                backgroundColor: AppTheme.mystic,
                resizeToAvoidBottomInset: false,
                body: CustomScrollView(
                  controller: widget.controller,
                  slivers: [
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 14,
                              bottom: 30,
                            ),
                            child: DefaultAppBar(
                              title: 'Написать в поддержку',
                              backgroundColor: AppTheme.mystic,
                              topRightWidget: NormalIconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  Keys.mainNav.currentState!.pop();
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    DefaultFormsSection(
                      topic: widget.topic?.id,
                      question: widget.question?.id,
                    ),
                    const ExtraFormsSection(),
                  ],
                ),
                floatingActionButton: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: StaticData.sidePadding,
                  ),
                  child: BlueButtonWithText(
                    text: 'Отправить',
                    onPressed: () {
                      BlocProvider.of<FieldsBloc>(context).add(
                        FieldsSend(
                          email: state.email,
                          topic: state.topic,
                          question: state.question,
                        ),
                      );
                    },
                  ),
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerFloat,
              );
            },
          ),
        ),
      ),
    );
  }
}
