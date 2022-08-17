import 'package:bausch/packages/bottom_sheet/src/flexible_bottom_sheet_route.dart';
import 'package:bausch/sections/my_lenses/choose_lenses/choose_lenses_wm.dart';
import 'package:bausch/sections/my_lenses/choose_lenses/choose_product_sheet.dart';
import 'package:bausch/sections/order_registration/widgets/single_picker_screen.dart';
import 'package:bausch/sections/sheets/sheet.dart';
import 'package:bausch/sections/sheets/widgets/warning_widget.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/buttons/focus_button.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:bausch/widgets/select_widgets/custom_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class ChooseLensesScreen extends CoreMwwmWidget<ChooseLensesWM> {
  final bool isEditing;
  ChooseLensesScreen({this.isEditing = false, Key? key})
      : super(
          key: key,
          widgetModelBuilder: (context) => ChooseLensesWM(context: context),
        );

  @override
  WidgetState<CoreMwwmWidget<ChooseLensesWM>, ChooseLensesWM>
      createWidgetState() => _ChooseLensesScreenState();
}

class _ChooseLensesScreenState
    extends WidgetState<ChooseLensesScreen, ChooseLensesWM> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar(
        title: 'Выберите линзы',
        backgroundColor: AppTheme.mystic,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(
          horizontal: StaticData.sidePadding,
          vertical: 30,
        ),
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FocusButton(
                labelText: 'Продукт',
                onPressed: () async {
                  await showFlexibleBottomSheet<void>(
                    useRootNavigator: false,
                    minHeight: 0,
                    initHeight: 0.95,
                    maxHeight: 0.95,
                    anchors: [0, 0.6, 0.95],
                    context: context,
                    isCollapsible: true,
                    builder: (context, controller, d) {
                      return const SheetWidget(
                        child: ChooseProductSheet(),
                        withPoints: false,
                      );
                    },
                  );
                },
              ),
              if (true)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Warning.warning(
                    'Выберите линзы, которыми вы пользуетесь',
                  ),
                ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(top: 30, bottom: 20),
            child: Text(
              'Правый глаз',
              style: AppStyles.h1,
            ),
          ),
          StreamedStateBuilder<String?>(
            streamedState: wm.rightDiopters,
            builder: (_, rightDiopters) {
              return Padding(
                padding: const EdgeInsets.only(
                  bottom: 4,
                ),
                child: FocusButton(
                  labelText: 'Диоптрии',
                  selectedText: rightDiopters,
                  onPressed: () async {
                    await wm.rightDiopters.accept(
                      await showModalBottomSheet<String?>(
                            context: context,
                            builder: (context) {
                              return const SinglePickerScreen(
                                title: 'Диоптрий',
                                variants: ['10', '5', '2', '1'],
                              );
                            },
                            barrierColor: Colors.black.withOpacity(0.8),
                          ) ??
                          rightDiopters,
                    );
                    await wm.validateFields();
                  },
                ),
              );
            },
          ),
          StreamedStateBuilder<String?>(
            streamedState: wm.rightCylinder,
            builder: (_, rightCylinder) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: FocusButton(
                  labelText: 'Цилиндр',
                  selectedText: rightCylinder,
                  onPressed: () async {
                    await wm.rightCylinder
                        .accept(await showModalBottomSheet<String?>(
                              context: context,
                              builder: (context) {
                                return const SinglePickerScreen(
                                  title: 'Цилиндр',
                                  variants: ['10', '5', '2', '1'],
                                );
                              },
                              barrierColor: Colors.black.withOpacity(0.8),
                            ) ??
                            rightCylinder);
                    await wm.validateFields();
                  },
                ),
              );
            },
          ),
          StreamedStateBuilder<String?>(
            streamedState: wm.rightAxis,
            builder: (_, rightAxis) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: FocusButton(
                  labelText: 'Ось',
                  selectedText: rightAxis,
                  onPressed: () async {
                    await wm.rightAxis
                        .accept(await showModalBottomSheet<String?>(
                              context: context,
                              builder: (context) {
                                return const SinglePickerScreen(
                                  title: 'Ось',
                                  variants: ['10', '5', '2', '1'],
                                );
                              },
                              barrierColor: Colors.black.withOpacity(0.8),
                            ) ??
                            rightAxis);
                    await wm.validateFields();
                  },
                ),
              );
            },
          ),
          StreamedStateBuilder<String?>(
            streamedState: wm.rightAddidations,
            builder: (_, rightAddidations) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: FocusButton(
                  labelText: 'Аддидация',
                  selectedText: rightAddidations,
                  onPressed: () async {
                    await wm.rightAddidations
                        .accept(await showModalBottomSheet<String?>(
                              context: context,
                              builder: (context) {
                                return const SinglePickerScreen(
                                  title: 'Аддидация',
                                  variants: ['10', '5', '2', '1'],
                                );
                              },
                              barrierColor: Colors.black.withOpacity(0.8),
                            ) ??
                            rightAddidations);
                    await wm.validateFields();
                  },
                ),
              );
            },
          ),
          const Padding(
            padding: EdgeInsets.only(top: 30, bottom: 22),
            child: Text(
              'Левый глаз',
              style: AppStyles.h1,
            ),
          ),
          Row(
            children: [
              StreamedStateBuilder<bool>(
                streamedState: wm.isLeftEqual,
                builder: (_, isLeftEqual) => CustomCheckbox(
                  marginNeeded: false,
                  value: isLeftEqual,
                  onChanged: (value) async {
                    await wm.changeEyesEquality(areEqual: value!);
                  },
                  borderRadius: 2,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              const Text('Совпадает с правым', style: AppStyles.p1),
            ],
          ),
          const SizedBox(height: 20),
          StreamedStateBuilder<String?>(
            streamedState: wm.leftDiopters,
            builder: (_, leftDiopters) {
              return Padding(
                padding: const EdgeInsets.only(
                  bottom: 4,
                ),
                child: FocusButton(
                  labelText: 'Диоптрии',
                  selectedText: leftDiopters,
                  onPressed: () async {
                    final newValue = await showModalBottomSheet<String?>(
                          context: context,
                          builder: (context) {
                            return const SinglePickerScreen(
                              title: 'Диоптрий',
                              variants: ['10', '5', '2', '1'],
                            );
                          },
                          barrierColor: Colors.black.withOpacity(0.8),
                        ) ??
                        leftDiopters;
                    if (newValue != null && newValue != leftDiopters) {
                      await wm.changeEyesEquality(areEqual: false);
                    }
                    await wm.leftDiopters.accept(newValue ?? leftDiopters);
                    await wm.validateFields();
                  },
                ),
              );
            },
          ),
          StreamedStateBuilder<String?>(
            streamedState: wm.leftCylinder,
            builder: (_, leftCylinder) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: FocusButton(
                  labelText: 'Цилиндр',
                  selectedText: leftCylinder,
                  onPressed: () async {
                    final newValue = await showModalBottomSheet<String?>(
                          context: context,
                          builder: (context) {
                            return const SinglePickerScreen(
                              title: 'Цилиндр',
                              variants: ['10', '5', '2', '1'],
                            );
                          },
                          barrierColor: Colors.black.withOpacity(0.8),
                        ) ??
                        leftCylinder;
                    if (newValue != null && newValue != leftCylinder) {
                      await wm.changeEyesEquality(areEqual: false);
                    }
                    await wm.leftCylinder.accept(newValue ?? leftCylinder);
                    await wm.validateFields();
                  },
                ),
              );
            },
          ),
          StreamedStateBuilder<String?>(
            streamedState: wm.leftAxis,
            builder: (_, leftAxis) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: FocusButton(
                  labelText: 'Ось',
                  selectedText: leftAxis,
                  onPressed: () async {
                    final newValue = await showModalBottomSheet<String?>(
                          context: context,
                          builder: (context) {
                            return const SinglePickerScreen(
                              title: 'Ось',
                              variants: ['10', '5', '2', '1'],
                            );
                          },
                          barrierColor: Colors.black.withOpacity(0.8),
                        ) ??
                        leftAxis;
                    if (newValue != null && newValue != leftAxis) {
                      await wm.changeEyesEquality(areEqual: false);
                    }
                    await wm.leftAxis.accept(newValue ?? leftAxis);
                    await wm.validateFields();
                  },
                ),
              );
            },
          ),
          StreamedStateBuilder<String?>(
            streamedState: wm.leftAddidations,
            builder: (_, leftAddidations) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: FocusButton(
                  labelText: 'Аддидация',
                  selectedText: leftAddidations,
                  onPressed: () async {
                    final newValue = await showModalBottomSheet<String?>(
                          context: context,
                          builder: (context) {
                            return const SinglePickerScreen(
                              title: 'Аддидация',
                              variants: ['10', '5', '2', '1'],
                            );
                          },
                          barrierColor: Colors.black.withOpacity(0.8),
                        ) ??
                        leftAddidations;
                    if (newValue != null && newValue != leftAddidations) {
                      await wm.changeEyesEquality(areEqual: false);
                    }
                    await wm.leftAddidations
                        .accept(newValue ?? leftAddidations);
                    await wm.validateFields();
                  },
                ),
              );
            },
          ),
          StreamedStateBuilder<bool>(
            streamedState: wm.areFieldsValid,
            builder: (_, areFieldsValid) => BlueButtonWithText(
              text: widget.isEditing ? 'Сохранить' : 'Добавить',
              onPressed: areFieldsValid
                  ? () => widget.isEditing
                      ? Keys.mainContentNav.currentState!.pop()
                      : Keys.mainContentNav.currentState!
                          .pushReplacementNamed('/my_lenses')
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
