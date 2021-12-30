import 'package:bausch/models/add_points/quiz/quiz_answer_model.dart';
import 'package:bausch/models/add_points/quiz/quiz_model.dart';
import 'package:bausch/sections/sheets/screens/add_points/quiz/widget_model/quiz_screen_wm.dart';
import 'package:bausch/sections/sheets/widgets/custom_sheet_scaffold.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/buttons/button_with_points_content.dart';
import 'package:bausch/widgets/loader/animated_loader.dart';
import 'package:bausch/widgets/select_widgets/custom_radio.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class QuizScreenArguments {
  final QuizModel model;

  QuizScreenArguments({
    required this.model,
  });
}

class QuizScreen extends CoreMwwmWidget<QuizScreenWM>
    implements QuizScreenArguments {
  final ScrollController controller;
  @override
  final QuizModel model;
  QuizScreen({
    required this.controller,
    required this.model,
    Key? key,
  }) : super(
          key: key,
          widgetModelBuilder: (context) => QuizScreenWM(
            context: context,
            quizModel: model,
          ),
        );

  @override
  WidgetState<CoreMwwmWidget<QuizScreenWM>, QuizScreenWM> createWidgetState() =>
      _QuizScreenState();
}

class _QuizScreenState extends WidgetState<QuizScreen, QuizScreenWM> {
  //final textEditingController = TextEditingController();
  //List<QuizAnswerModel> answers = [];
  // int page = 0;

  // int _selected = 0;

  @override
  void dispose() {
    super.dispose();
    wm.textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomSheetScaffold(
      controller: widget.controller,
      resizeToAvoidBottomInset: false,
      appBar: const CustomSliverAppbar(
        padding: EdgeInsets.all(18),
        iconColor: AppTheme.mystic,
      ),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            StaticData.sidePadding,
            StaticData.sidePadding,
            StaticData.sidePadding,
            27,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                //* Верхний контейнер
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                  ),
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          const SizedBox(
                            height: 64,
                          ),
                          Image.network(
                            wm.quizModel.detailModel.icon,
                            fit: BoxFit.cover,
                            height: 200,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: StaticData.sidePadding,
                            ),
                            child: Text(
                              wm.quizModel.detailModel.title,
                              style: AppStyles.h1,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: 30,
                            ),
                            child: ButtonContent(
                              price: '+${widget.model.reward}',
                              textStyle: AppStyles.h1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.only(
            left: StaticData.sidePadding,
            right: StaticData.sidePadding,
          ),
          sliver: StreamedStateBuilder<int>(
            streamedState: wm.page,
            builder: (_, page) {
              return SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 4,
                      ),
                      child: Text(
                        widget.model.content[page].title,
                        style: AppStyles.h2,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 30,
                      ),
                      child: Text(
                        '${page + 1}/${wm.quizModel.content.length}',
                        style: AppStyles.h3,
                      ),
                    ),
                    Column(
                      children: List.generate(
                        widget.model.content[page].answers.length,
                        (i) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              bottom: 4,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              padding: const EdgeInsets.only(
                                top: 12,
                                left: 12,
                                right: 12,
                                bottom: 20,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      wm.quizModel.content[page].answers[i]
                                          .title,
                                      style: AppStyles.h3,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  StreamedStateBuilder<int>(
                                    streamedState: wm.selected,
                                    builder: (_, selected) {
                                      return CustomRadio(
                                        value: i,
                                        groupValue: selected,
                                        onChanged: (v) {
                                          wm.selected.accept(i);
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    if (wm.quizModel.content[page].other != null)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        margin: const EdgeInsets.only(
                          bottom: 4,
                        ),
                        padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
                        child: TextField(
                          controller: wm.textEditingController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: wm.quizModel.content[page].other!.title,
                            hintStyle: AppStyles.h3,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.only(
            left: 12,
            right: 12,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                StreamedStateBuilder<bool>(
                  streamedState: wm.loadingState,
                  builder: (_, isLoading) {
                    return isLoading
                        ? const BlueButtonWithText(
                            text: '',
                            icon: AnimatedLoader(),
                          )
                        : BlueButtonWithText(
                            text: 'Далее',
                            onPressed: wm.buttonAction,
                          );
                  },
                ),
                const SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
