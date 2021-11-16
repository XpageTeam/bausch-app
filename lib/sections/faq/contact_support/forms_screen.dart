import 'package:bausch/models/faq/question_model.dart';
import 'package:bausch/models/faq/topic_model.dart';
import 'package:bausch/sections/faq/bloc/forms/fields_bloc.dart';
import 'package:bausch/sections/faq/contact_support/default_forms_section.dart';
import 'package:bausch/sections/faq/contact_support/extra_forms_section.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/buttons/normal_icon_button.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FormsScreen extends StatefulWidget {
  final ScrollController controller;

  final QuestionModel? question;

  final TopicModel? topic;
  const FormsScreen({
    required this.controller,
    this.question,
    this.topic,
    Key? key,
  }) : super(key: key);

  @override
  State<FormsScreen> createState() => _FormsScreenState();
}

class _FormsScreenState extends State<FormsScreen> {
  late FieldsBloc fieldsBloc;

  @override
  void initState() {
    super.initState();
    fieldsBloc = BlocProvider.of<FieldsBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(
                  height: 120,
                ),
              ],
            ),
          ),
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
                email: fieldsBloc.state.email,
                topic: fieldsBloc.state.topic,
                question: fieldsBloc.state.question,
                files: fieldsBloc.state.files,
                extra: fieldsBloc.state.extra,
              ),
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
