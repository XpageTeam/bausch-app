import 'package:bausch/models/add_points/quiz/quiz_content_model.dart';
import 'package:bausch/models/add_points/quiz/quiz_model.dart';
import 'package:bausch/sections/sheets/screens/add_points/quiz/widget_model/quiz_screen_wm.dart';
import 'package:bausch/sections/sheets/widgets/custom_sheet_scaffold.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/buttons/button_with_points_content.dart';
import 'package:bausch/widgets/loader/ui_loader.dart';
import 'package:bausch/widgets/select_widgets/custom_radio.dart';
import 'package:extended_image/extended_image.dart';
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
  @override
  Widget build(BuildContext context) {
    return CustomSheetScaffold(
      controller: widget.controller,
      onScrolled: (offset) {
        if (offset > 60) {
          wm.colorState.accept(AppTheme.turquoiseBlue);
        } else {
          wm.colorState.accept(AppTheme.mystic);
        }
      },
      //resizeToAvoidBottomInset: false,
      appBar: StreamedStateBuilder<Color>(
        streamedState: wm.colorState,
        builder: (_, color) {
          return CustomSliverAppbar(
            padding: const EdgeInsets.all(18),
            iconColor: color,
          );
        },
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
                          ExtendedImage.network(
                            wm.quizModel.detailModel.icon,
                            fit: BoxFit.cover,
                            height: 200,
                            printError: false,
                            loadStateChanged: loadStateChangedFunction,
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
                            key: wm.keyForOffset,
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
          padding: const EdgeInsets.symmetric(
            horizontal: StaticData.sidePadding,
          ),
          sliver: StreamedStateBuilder<QuizContentModel>(
            streamedState: wm.contentStreamed,
            builder: (_, content) {
              return SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 4,
                      ),
                      child: Text(
                        content.title,
                        style: AppStyles.h2,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 30,
                      ),
                      child: Text(
                        wm.progressText,
                        style: AppStyles.h3,
                      ),
                    ),
                    Column(
                      children: List.generate(
                        content.answers.length,
                        (i) {
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: content.answers.length - 1 == i ? 0 : 4,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                wm.addToAnswersAction(i);
                              },
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
                                        content.answers[i].title,
                                        style: AppStyles.h3,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    StreamedStateBuilder<List<int>>(
                                      streamedState: wm.selectedIndexes,
                                      builder: (_, selected) {
                                        return CustomRadio(
                                          value: i,
                                          selected: selected
                                              .any((index) => index == i),
                                          onChanged: (v) {
                                            wm.addToAnswersAction(i);
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    if (content.other != null)
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
                        child: GestureDetector(
                          onTap: wm.setFocus,
                          child: TextField(
                            focusNode: wm.focusNode,
                            controller: wm.textEditingController,
                            maxLines: 4,
                            decoration: InputDecoration(
                              hintText: content.other!.title,
                              hintStyle: AppStyles.h3,
                            ),
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 40,
                      ),
                      child: StreamedStateBuilder<bool>(
                        streamedState: wm.canMoveToNextPage,
                        builder: (_, canMoveNextPage) {
                          return StreamedStateBuilder<bool>(
                            streamedState: wm.loadingState,
                            builder: (_, isLoading) {
                              return isLoading
                                  ? const BlueButtonWithText(
                                      text: '',
                                      icon: UiCircleLoader(),
                                    )
                                  : BlueButtonWithText(
                                      text: 'Далее',
                                      onPressed: canMoveNextPage
                                          ? () => wm.buttonAction()
                                          : null,
                                    );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        // SliverPadding(
        //   padding: const EdgeInsets.only(
        //     left: 12,
        //     right: 12,
        //   ),
        //   sliver: SliverList(
        //     delegate: SliverChildListDelegate(
        //       [
        //         StreamedStateBuilder<bool>(
        //           streamedState: wm.loadingState,
        //           builder: (_, isLoading) {
        //             return isLoading
        //                 ? const BlueButtonWithText(
        //                     text: '',
        //                     icon: AnimatedLoader(),
        //                   )
        //                 : BlueButtonWithText(
        //                     text: 'Далее',
        //                     onPressed: wm.buttonAction,
        //                   );
        //           },
        //         ),
        //         const SizedBox(
        //           height: 40,
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
