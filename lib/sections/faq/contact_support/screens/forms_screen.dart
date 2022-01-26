import 'package:bausch/models/faq/forms/field_model.dart';
import 'package:bausch/models/faq/question_model.dart';
import 'package:bausch/models/faq/topic_model.dart';
import 'package:bausch/sections/faq/attach_files_screen.dart';
import 'package:bausch/sections/faq/contact_support/default_forms_section.dart';
import 'package:bausch/sections/faq/contact_support/extra_forms_section.dart';
import 'package:bausch/sections/faq/contact_support/topic_question_select.dart';
import 'package:bausch/sections/faq/contact_support/wm/forms_screen_wm.dart';
import 'package:bausch/sections/sheets/widgets/custom_sheet_scaffold.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/buttons/white_button.dart';
import 'package:bausch/widgets/loader/animated_loader.dart';
import 'package:bausch/widgets/loader/ui_loader.dart';
import 'package:flutter/material.dart';
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
  Color iconColor = Colors.white;
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
        onScrolled: (offset) {
          if (offset > 60) {
            if (iconColor != AppTheme.turquoiseBlue) {
              setState(() {
                iconColor = AppTheme.turquoiseBlue;
              });
            }
          } else {
            setState(() {
              iconColor = Colors.white;
            });
          }
        },
        appBar: CustomSliverAppbar(
          iconColor: iconColor,
          padding: const EdgeInsets.symmetric(
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
            builder: (_, state) {
              return DefaultFormsSection(
                defaultFields: state,
              );
            },
          ),

          if (!wm.defaultFieldsList.value.hasError &&
              !wm.defaultFieldsList.value.isLoading)
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                StaticData.sidePadding,
                0,
                StaticData.sidePadding,
                4,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    WhiteButton(
                      text: 'Прикрепить файлы',
                      icon: const SizedBox(),
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          '/add_files',
                          arguments: AttachFilesScreenArguments(
                            fieldModel: FieldModel(
                              id: 0,
                              type: 'type',
                              name: 'name',
                              xmlId: 'xmlId',
                            ),
                            formScreenWM: wm,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          const TopicQuestionSelect(),

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
                    streamedState: wm.buttonEnabledState,
                    builder: (_, isEnabled) {
                      return isEnabled
                          ? StreamedStateBuilder<bool>(
                              streamedState: wm.loadingState,
                              builder: (_, isLoading) {
                                return isLoading
                                    ? const BlueButtonWithText(
                                        text: '',
                                        icon: UiCircleLoader(),
                                        //onPressed: () {},
                                      )
                                    : BlueButtonWithText(
                                        text: 'Отправить',
                                        onPressed: wm.sendAction,
                                      );
                              },
                            )
                          : const BlueButtonWithText(
                              text: 'Отправить',
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
                  height: 40,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
