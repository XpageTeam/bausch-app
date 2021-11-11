import 'package:bausch/models/faq/field_model.dart';
import 'package:bausch/models/faq/question_model.dart';
import 'package:bausch/models/faq/topic_model.dart';
import 'package:bausch/sections/faq/bloc/forms/fields_bloc.dart';
import 'package:bausch/sections/faq/contact_support/default_forms_section.dart';
import 'package:bausch/sections/faq/contact_support/extra_forms_section.dart';
import 'package:bausch/sections/faq/contact_support/form_builder.dart';
import 'package:bausch/sections/faq/contact_support/select.dart';
import 'package:bausch/sections/faq/cubit/forms/forms_cubit.dart';
import 'package:bausch/sections/faq/cubit/forms_extra/forms_extra_cubit.dart';
import 'package:bausch/sections/faq/question_screen.dart';
import 'package:bausch/sections/loader/widgets/animated_loader.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/buttons/normal_icon_button.dart';
import 'package:bausch/widgets/buttons/select_button.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:bausch/widgets/inputs/default_text_input.dart';
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
  final FieldsBloc fieldsBloc = FieldsBloc();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.question != null) {
      fieldsBloc.add(FieldsSetQuestion(widget.question!.id));
    }

    if (widget.topic != null) {
      fieldsBloc.add(FieldsSetTopic(widget.topic!.id));
    }

    debugPrint('Question: ${widget.question?.id}, topic: ${widget.topic?.id}');
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(5),
        topRight: Radius.circular(5),
      ),
      child: BlocProvider.value(
        value: fieldsBloc,
        child: BlocBuilder<FieldsBloc, FieldsState>(
          //bloc: fieldsBloc,
          builder: (context, fieldState) {
            return Scaffold(
              backgroundColor: AppTheme.mystic,
              resizeToAvoidBottomInset: false,
              //extendBody: true,
              primary: false,
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
                    arguments: ContactSupportScreenArguments(
                      topic: widget.topic,
                      question: widget.question,
                    ),
                  ),
                  if (widget.question?.id != null)
                    ExtraFormsSection(id: widget.question!.id),
                ],
              ),
              floatingActionButton: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: StaticData.sidePadding,
                ),
                child: BlueButtonWithText(
                  text: 'Отправить',
                  onPressed: () {
                    fieldsBloc.add(
                      FieldsSend(
                        email: fieldState.email,
                        topic: widget.topic!.id,
                        question: widget.question!.id,
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
    );
  }
}
