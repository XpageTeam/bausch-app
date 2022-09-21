import 'package:bausch/models/my_lenses/lens_product_list_model.dart';
import 'package:bausch/models/my_lenses/lenses_pair_model.dart';
import 'package:bausch/sections/home/widgets/containers/white_container_with_rounded_corners.dart';
import 'package:bausch/sections/my_lenses/choose_lenses/choose_lenses_wm.dart';
import 'package:bausch/sections/order_registration/widgets/single_picker_screen.dart';
import 'package:bausch/sections/sheets/widgets/warning_widget.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/buttons/focus_button.dart';
import 'package:bausch/widgets/buttons/grey_button.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:bausch/widgets/select_widgets/custom_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class ChooseLensesScreen extends CoreMwwmWidget<ChooseLensesWM> {
  final bool isEditing;
  final LensesPairModel? lensesPairModel;
  ChooseLensesScreen({this.isEditing = false, this.lensesPairModel, Key? key})
      : super(
          key: key,
          widgetModelBuilder: (context) => ChooseLensesWM(
            context: context,
            editLensPairModel: lensesPairModel,
          ),
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
      body: StreamedStateBuilder<LensProductModel?>(
        streamedState: wm.currentProduct,
        builder: (_, currendProduct) => ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: StaticData.sidePadding,
            vertical: 30,
          ),
          children: [
            if (currendProduct == null)
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FocusButton(
                    labelText: 'Продукт',
                    onPressed: () async => wm.showProductSheet(context),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Warning.warning(
                      'Выберите линзы, которыми вы пользуетесь',
                    ),
                  ),
                ],
              )
            else
              WhiteContainerWithRoundedCorners(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: StaticData.sidePadding,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currendProduct.name,
                                style: AppStyles.h2,
                              ),
                              Text(
                                currendProduct.lifeTime > 1
                                    ? 'Плановой замены \n${currendProduct.lifeTime} суток'
                                    : 'Однодневные',
                                style: AppStyles.p1,
                              ),
                            ],
                          ),
                        ),
                        Image.network(
                          currendProduct.image,
                          height: 100,
                          width: 100,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: GreyButton(
                        text: 'Выбрать другие',
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        onPressed: () async => wm.showProductSheet(context),
                      ),
                    ),
                  ],
                ),
              ),
            if (currendProduct != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 30, bottom: 20),
                    child: Text(
                      'Правый глаз',
                      style: AppStyles.h1,
                    ),
                  ),
                  StreamedStateBuilder<PairModel>(
                    streamedState: wm.rightPair,
                    builder: (_, rightPair) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (currendProduct.diopters.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: 4,
                              ),
                              child: FocusButton(
                                labelText: 'Диоптрии',
                                selectedText: rightPair.diopters,
                                onPressed: () async {
                                  final newValue =
                                      await showModalBottomSheet<String?>(
                                            context: context,
                                            builder: (context) {
                                              return SinglePickerScreen(
                                                title: 'Диоптрии',
                                                variants:
                                                    currendProduct.diopters,
                                              );
                                            },
                                            barrierColor:
                                                Colors.black.withOpacity(0.8),
                                          ) ??
                                          rightPair.diopters;

                                  await wm.rightPair.accept(
                                    rightPair.copyWith(diopters: newValue),
                                  );
                                  await wm.validateFields();
                                },
                              ),
                            ),
                          if (currendProduct.cylinder.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: FocusButton(
                                labelText: 'Цилиндр',
                                selectedText: rightPair.cylinder,
                                onPressed: () async {
                                  final newValue =
                                      await showModalBottomSheet<String?>(
                                            context: context,
                                            builder: (context) {
                                              return SinglePickerScreen(
                                                title: 'Цилиндр',
                                                variants:
                                                    currendProduct.cylinder,
                                              );
                                            },
                                            barrierColor:
                                                Colors.black.withOpacity(0.8),
                                          ) ??
                                          rightPair.cylinder;

                                  await wm.rightPair.accept(
                                    rightPair.copyWith(cylinder: newValue),
                                  );
                                  await wm.validateFields();
                                },
                              ),
                            ),
                          if (currendProduct.axis.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: FocusButton(
                                labelText: 'Ось',
                                selectedText: rightPair.axis,
                                onPressed: () async {
                                  final newValue =
                                      await showModalBottomSheet<String?>(
                                            context: context,
                                            builder: (context) {
                                              return SinglePickerScreen(
                                                title: 'Ось',
                                                variants: currendProduct.axis,
                                              );
                                            },
                                            barrierColor:
                                                Colors.black.withOpacity(0.8),
                                          ) ??
                                          rightPair.axis;

                                  await wm.rightPair.accept(
                                    rightPair.copyWith(axis: newValue),
                                  );
                                  await wm.validateFields();
                                },
                              ),
                            ),
                          if (currendProduct.addition.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: FocusButton(
                                labelText: 'Аддидация',
                                selectedText: rightPair.addition,
                                onPressed: () async {
                                  final newValue =
                                      await showModalBottomSheet<String?>(
                                            context: context,
                                            builder: (context) {
                                              return SinglePickerScreen(
                                                title: 'Аддидация',
                                                variants:
                                                    currendProduct.addition,
                                              );
                                            },
                                            barrierColor:
                                                Colors.black.withOpacity(0.8),
                                          ) ??
                                          rightPair.addition;

                                  await wm.rightPair.accept(
                                    rightPair.copyWith(addition: newValue),
                                  );
                                  await wm.validateFields();
                                },
                              ),
                            ),
                        ],
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
                  if (currendProduct.diopters.isNotEmpty)
                    StreamedStateBuilder<PairModel>(
                      streamedState: wm.leftPair,
                      builder: (_, leftPair) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: 4,
                              ),
                              child: FocusButton(
                                labelText: 'Диоптрии',
                                selectedText: leftPair.diopters,
                                onPressed: () async {
                                  final newValue =
                                      await showModalBottomSheet<String?>(
                                            context: context,
                                            builder: (context) {
                                              return SinglePickerScreen(
                                                title: 'Диоптрии',
                                                variants:
                                                    currendProduct.diopters,
                                              );
                                            },
                                            barrierColor:
                                                Colors.black.withOpacity(0.8),
                                          ) ??
                                          leftPair.diopters;
                                  if (newValue != null &&
                                      newValue != leftPair.diopters) {
                                    await wm.changeEyesEquality(
                                      areEqual: false,
                                    );
                                  }
                                  await wm.leftPair.accept(
                                    leftPair.copyWith(diopters: newValue),
                                  );
                                  await wm.validateFields();
                                },
                              ),
                            ),
                            if (currendProduct.cylinder.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: FocusButton(
                                  labelText: 'Цилиндр',
                                  selectedText: leftPair.cylinder,
                                  onPressed: () async {
                                    final newValue =
                                        await showModalBottomSheet<String?>(
                                              context: context,
                                              builder: (context) {
                                                return SinglePickerScreen(
                                                  title: 'Цилиндр',
                                                  variants:
                                                      currendProduct.cylinder,
                                                );
                                              },
                                              barrierColor:
                                                  Colors.black.withOpacity(0.8),
                                            ) ??
                                            leftPair.cylinder;
                                    if (newValue != null &&
                                        newValue != leftPair.cylinder) {
                                      await wm.changeEyesEquality(
                                        areEqual: false,
                                      );
                                    }
                                    await wm.leftPair.accept(
                                      leftPair.copyWith(cylinder: newValue),
                                    );
                                    await wm.validateFields();
                                  },
                                ),
                              ),
                            if (currendProduct.axis.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: FocusButton(
                                  labelText: 'Ось',
                                  selectedText: leftPair.axis,
                                  onPressed: () async {
                                    final newValue =
                                        await showModalBottomSheet<String?>(
                                              context: context,
                                              builder: (context) {
                                                return SinglePickerScreen(
                                                  title: 'Ось',
                                                  variants: currendProduct.axis,
                                                );
                                              },
                                              barrierColor:
                                                  Colors.black.withOpacity(0.8),
                                            ) ??
                                            leftPair.axis;
                                    if (newValue != null &&
                                        newValue != leftPair.axis) {
                                      await wm.changeEyesEquality(
                                        areEqual: false,
                                      );
                                    }
                                    await wm.leftPair.accept(
                                      leftPair.copyWith(axis: newValue),
                                    );
                                    await wm.validateFields();
                                  },
                                ),
                              ),
                            if (currendProduct.addition.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: FocusButton(
                                  labelText: 'Аддидация',
                                  selectedText: leftPair.addition?.toString(),
                                  onPressed: () async {
                                    final newValue =
                                        await showModalBottomSheet<String?>(
                                              context: context,
                                              builder: (context) {
                                                return SinglePickerScreen(
                                                  title: 'Аддидация',
                                                  variants:
                                                      currendProduct.addition,
                                                );
                                              },
                                              barrierColor:
                                                  Colors.black.withOpacity(0.8),
                                            ) ??
                                            leftPair.addition;
                                    if (newValue != null &&
                                        newValue != leftPair.addition) {
                                      await wm.changeEyesEquality(
                                        areEqual: false,
                                      );
                                    }
                                    await wm.leftPair.accept(
                                      leftPair.copyWith(addition: newValue),
                                    );
                                    await wm.validateFields();
                                  },
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  StreamedStateBuilder<bool>(
                    streamedState: wm.areFieldsValid,
                    builder: (_, areFieldsValid) => BlueButtonWithText(
                      text: widget.isEditing ? 'Сохранить' : 'Добавить',
                      onPressed: areFieldsValid
                          ? () async =>
                              wm.onAcceptPressed(isEditing: widget.isEditing)
                          : null,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
