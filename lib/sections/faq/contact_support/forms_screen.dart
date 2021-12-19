import 'package:bausch/models/faq/question_model.dart';
import 'package:bausch/models/faq/topic_model.dart';
import 'package:bausch/sections/faq/bloc/forms/fields_bloc.dart';
import 'package:bausch/sections/faq/contact_support/default_forms_section.dart';
import 'package:bausch/sections/faq/contact_support/extra_forms_section.dart';
import 'package:bausch/sections/sheets/widgets/custom_sheet_scaffold.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
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
    return BlocBuilder<FieldsBloc, FieldsState>(
      bloc: fieldsBloc,
      builder: (context, state) {
        return CustomSheetScaffold(
          controller: widget.controller,
          appBar: const CustomSliverAppbar(
            padding: EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
          ),
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 26,
                      bottom: 42,
                    ),
                    child: Center(
                      child: Text(
                        'Написать в поддержку',
                        style: AppStyles.h2,
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
          floatingActionButton: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: StaticData.sidePadding,
            ),
            child: BlueButtonWithText(
              text: 'Отправить',
              onPressed: ((fieldsBloc.state.email != '') &&
                      (fieldsBloc.state.topic != 0) &&
                      (fieldsBloc.state.question != 0))
                  ? () {
                      fieldsBloc.add(
                        FieldsSend(
                          email: state.email,
                          topic: state.topic,
                          question: state.question,
                          files: state.files,
                          extra: state.extra,
                        ),
                      );
                    }
                  : null,
            ),
          ),
        );
      },
    );
  }
}
