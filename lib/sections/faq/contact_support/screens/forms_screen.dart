import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/models/faq/forms/field_model.dart';
import 'package:bausch/models/faq/question_model.dart';
import 'package:bausch/models/faq/topic_model.dart';
import 'package:bausch/sections/faq/bloc/forms/fields_bloc.dart';
import 'package:bausch/sections/faq/contact_support/default_forms_section.dart';
import 'package:bausch/sections/faq/contact_support/extra_forms_section.dart';
import 'package:bausch/sections/faq/contact_support/topic_question_select.dart';
import 'package:bausch/sections/faq/contact_support/wm/forms_screen_wm.dart';
import 'package:bausch/sections/sheets/widgets/custom_sheet_scaffold.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/loader/animated_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class FormsScreen extends CoreMwwmWidget<FormScreenWM> {
  final ScrollController controller;

  final QuestionModel? question;

  final TopicModel? topic;

  FormsScreen({
    required this.controller,
    this.question,
    this.topic,
    Key? key,
  }) : super(
          key: key,
          widgetModelBuilder: (context) {
            return FormScreenWM(
              context: context,
              topic: topic,
              question: question,
            );
          },
        );

  @override
  WidgetState<CoreMwwmWidget<FormScreenWM>, FormScreenWM> createWidgetState() =>
      _FormsScreenState();
}

class _FormsScreenState extends WidgetState<FormsScreen, FormScreenWM> {
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) {
        return wm;
      },
      lazy: false,
      child: CustomSheetScaffold(
        resizeToAvoidBottomInset: false,
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

          //* Стандартные поля
          EntityStateBuilder<List<FieldModel>>(
            streamedState: wm.defaultFieldsList,
            loadingChild: SliverList(
              delegate: SliverChildListDelegate(
                [
                  const Center(
                    child: AnimatedLoader(),
                  ),
                ],
              ),
            ),
            errorBuilder: (context, e) {
              e as CustomException;
              debugPrint(e.title);

              return SliverList(
                delegate: SliverChildListDelegate(
                  [
                    const SizedBox(),
                  ],
                ),
              );
            },
            builder: (_, state) {
              return DefaultFormsSection(
                defaultFields: state,
              );
            },
          ),
          TopicQuestionSelect(),

          //* Дополнительные поля
          EntityStateBuilder<List<FieldModel>>(
            streamedState: wm.extraFieldsList,
            loadingChild: SliverList(
              delegate: SliverChildListDelegate(
                [
                  const Center(
                    child: AnimatedLoader(),
                  ),
                ],
              ),
            ),
            errorBuilder: (context, e) {
              e as CustomException;
              debugPrint(e.title);

              return SliverList(
                delegate: SliverChildListDelegate(
                  [
                    const SizedBox(),
                  ],
                ),
              );
            },
            builder: (_, state) {
              return ExtraFormsSection(
                exrtaFields: state,
              );
            },
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: StaticData.sidePadding,
                  ),
                  child: StreamedStateBuilder<bool>(
                    streamedState: wm.loadingState,
                    builder: (_, isLoading) {
                      return isLoading
                          ? const BlueButtonWithText(
                              text: '',
                              icon: AnimatedLoader(),
                              //onPressed: () {},
                            )
                          : BlueButtonWithText(
                              text: 'Отправить',
                              onPressed: wm.sendAction,
                            );
                    },
                  ),
                ),
              ],
            ),
          ),
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
    );
  }
}
