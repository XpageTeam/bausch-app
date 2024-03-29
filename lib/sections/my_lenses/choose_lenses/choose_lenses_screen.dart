import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/help/help_functions.dart';
import 'package:bausch/models/my_lenses/lens_product_list_model.dart';
import 'package:bausch/models/my_lenses/lenses_pair_model.dart';
import 'package:bausch/sections/home/widgets/containers/white_container_with_rounded_corners.dart';
import 'package:bausch/sections/my_lenses/choose_lenses/choose_lenses_wm.dart';
import 'package:bausch/sections/my_lenses/my_lenses_wm.dart';
import 'package:bausch/sections/my_lenses/widgets/sheets/activate_lenses_sheet.dart';
import 'package:bausch/sections/order_registration/widgets/single_picker_screen.dart';
import 'package:bausch/sections/sheets/widgets/warning_widget.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/bottom_info_block.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/buttons/focus_button.dart';
import 'package:bausch/widgets/buttons/grey_button.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:bausch/widgets/error_page.dart';
import 'package:bausch/widgets/loader/animated_loader.dart';
import 'package:bausch/widgets/loader/ui_loader.dart';
import 'package:bausch/widgets/select_widgets/custom_checkbox.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class ChooseLensesScreenArguments {
  final bool isEditing;
  final LensesPairModel? lensesPairModel;
  final LensProductModel? productBausch;
  final MyLensesWM? myLensesWM;

  ChooseLensesScreenArguments({
    required this.isEditing,
    this.lensesPairModel,
    this.productBausch,
    this.myLensesWM,
  });
}

class ChooseLensesScreen extends CoreMwwmWidget<ChooseLensesWM>
    implements ChooseLensesScreenArguments {
  @override
  final bool isEditing;
  @override
  final LensesPairModel? lensesPairModel;
  @override
  final LensProductModel? productBausch;
  @override
  final MyLensesWM? myLensesWM;
  ChooseLensesScreen({
    this.isEditing = false,
    this.lensesPairModel,
    this.productBausch,
    this.myLensesWM,
    Key? key,
  }) : super(
          key: key,
          widgetModelBuilder: (context) => ChooseLensesWM(
            context: context,
            editLensPairModel: lensesPairModel,
            productBausch: productBausch,
            myLensesWM: myLensesWM,
          ),
        );

  @override
  WidgetState<CoreMwwmWidget<ChooseLensesWM>, ChooseLensesWM>
      createWidgetState() => _ChooseLensesScreenState();
}

class _ChooseLensesScreenState
    extends WidgetState<ChooseLensesScreen, ChooseLensesWM> {
  bool isUpdating = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar(
        title: 'Выберите линзы',
        backgroundColor: AppTheme.mystic,
      ),
      body: EntityStateBuilder<bool>(
        streamedState: wm.allDataEntityState,
        loadingChild: const Center(
          child: AnimatedLoader(),
        ),
        errorBuilder: (context, e) => ErrorPage(
          title: (e as CustomException).title,
          buttonCallback: wm.loadAllData,
          buttonText: 'Обновить',
        ),
        builder: (_, __) {
          return StreamedStateBuilder<LensProductModel?>(
            streamedState: wm.currentProduct,
            builder: (_, currentProduct) => ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(
                left: StaticData.sidePadding,
                right: StaticData.sidePadding,
                top: 30,
                bottom: 20,
              ),
              children: [
                if (currentProduct == null)
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
                                    currentProduct.name,
                                    style: AppStyles.h2,
                                  ),
                                  Text(
                                    currentProduct.lifeTime > 1
                                        ? 'Плановой замены \nДо ${currentProduct.lifeTime} суток'
                                        : 'Однодневные',
                                    style: AppStyles.p1,
                                  ),
                                  Text(
                                    HelpFunctions.pairs(
                                      int.parse(currentProduct.count),
                                    ),
                                    style: AppStyles.p1,
                                  ),
                                ],
                              ),
                            ),
                            ExtendedImage.network(
                              currentProduct.image,
                              height: 100,
                              width: 100,
                              loadStateChanged: onLoadStateChanged,
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
                if (currentProduct != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 30, bottom: 20),
                        child: Text(
                          'Правый глаз ∙ R',
                          style: AppStyles.h1,
                        ),
                      ),
                      StreamedStateBuilder<PairModel>(
                        streamedState: wm.rightPair,
                        builder: (_, rightPair) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (currentProduct.basicCurvature.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 4,
                                  ),
                                  child: FocusButton(
                                    labelText: 'Базовая кривизна',
                                    selectedText: rightPair.basicCurvature,
                                    onPressed: () async {
                                      final newValue =
                                          await showModalBottomSheet<String?>(
                                                context: context,
                                                builder: (context) {
                                                  return SinglePickerScreen(
                                                    title: 'Базовая кривизна',
                                                    variants: currentProduct
                                                        .basicCurvature,
                                                  );
                                                },
                                                barrierColor: Colors.black
                                                    .withOpacity(0.8),
                                              ) ??
                                              rightPair.basicCurvature;

                                      await wm.rightPair.accept(
                                        rightPair.copyWith(
                                          basicCurvature: newValue,
                                        ),
                                      );
                                      await wm.validateFields();
                                    },
                                  ),
                                ),
                              if (currentProduct.diopters.isNotEmpty)
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
                                                    startId: wm.detectStartId(
                                                      currentProduct.diopters,
                                                    ),
                                                    title: 'Диоптрии',
                                                    variants:
                                                        currentProduct.diopters,
                                                  );
                                                },
                                                barrierColor: Colors.black
                                                    .withOpacity(0.8),
                                              ) ??
                                              rightPair.diopters;

                                      await wm.rightPair.accept(
                                        rightPair.copyWith(diopters: newValue),
                                      );
                                      await wm.validateFields();
                                    },
                                  ),
                                ),
                              if (currentProduct.cylinder.isNotEmpty)
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
                                                        currentProduct.cylinder,
                                                  );
                                                },
                                                barrierColor: Colors.black
                                                    .withOpacity(0.8),
                                              ) ??
                                              rightPair.cylinder;

                                      await wm.rightPair.accept(
                                        rightPair.copyWith(cylinder: newValue),
                                      );
                                      await wm.validateFields();
                                    },
                                  ),
                                ),
                              if (currentProduct.axis.isNotEmpty)
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
                                                    variants:
                                                        currentProduct.axis,
                                                  );
                                                },
                                                barrierColor: Colors.black
                                                    .withOpacity(0.8),
                                              ) ??
                                              rightPair.axis;

                                      await wm.rightPair.accept(
                                        rightPair.copyWith(axis: newValue),
                                      );
                                      await wm.validateFields();
                                    },
                                  ),
                                ),
                              if (currentProduct.addition.isNotEmpty)
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
                                                        currentProduct.addition,
                                                  );
                                                },
                                                barrierColor: Colors.black
                                                    .withOpacity(0.8),
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
                          'Левый глаз ∙ L',
                          style: AppStyles.h1,
                        ),
                      ),
                      StreamedStateBuilder<bool>(
                        streamedState: wm.isLeftEqual,
                        builder: (_, isLeftEqual) => GestureDetector(
                          onTap: () async =>
                              wm.changeEyesEquality(areEqual: !isLeftEqual),
                          // ignore:  use_colored_box
                          child: Container(
                            color: Colors.transparent,
                            child: Row(
                              children: [
                                CustomCheckbox(
                                  marginNeeded: false,
                                  value: isLeftEqual,
                                  onChanged: (value) async {
                                    await wm.changeEyesEquality(
                                      areEqual: value!,
                                    );
                                  },
                                  borderRadius: 2,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                const Text(
                                  'Совпадает с правым',
                                  style: AppStyles.p1,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      StreamedStateBuilder<PairModel>(
                        streamedState: wm.leftPair,
                        builder: (_, leftPair) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (currentProduct.basicCurvature.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 4,
                                  ),
                                  child: FocusButton(
                                    labelText: 'Базовая кривизна',
                                    selectedText: leftPair.basicCurvature,
                                    onPressed: () async {
                                      final newValue =
                                          await showModalBottomSheet<String?>(
                                                context: context,
                                                builder: (context) {
                                                  return SinglePickerScreen(
                                                    title: 'Базовая кривизна',
                                                    variants: currentProduct
                                                        .basicCurvature,
                                                  );
                                                },
                                                barrierColor: Colors.black
                                                    .withOpacity(0.8),
                                              ) ??
                                              leftPair.basicCurvature;
                                      if (newValue != null &&
                                          newValue != leftPair.basicCurvature) {
                                        await wm.changeEyesEquality(
                                          areEqual: false,
                                        );
                                      }
                                      await wm.leftPair.accept(
                                        leftPair.copyWith(
                                          basicCurvature: newValue,
                                        ),
                                      );
                                      await wm.validateFields();
                                    },
                                  ),
                                ),
                              if (currentProduct.diopters.isNotEmpty)
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
                                                    startId: wm.detectStartId(
                                                      currentProduct.diopters,
                                                    ),
                                                    title: 'Диоптрии',
                                                    variants:
                                                        currentProduct.diopters,
                                                  );
                                                },
                                                barrierColor: Colors.black
                                                    .withOpacity(0.8),
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
                              if (currentProduct.cylinder.isNotEmpty)
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
                                                        currentProduct.cylinder,
                                                  );
                                                },
                                                barrierColor: Colors.black
                                                    .withOpacity(0.8),
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
                              if (currentProduct.axis.isNotEmpty)
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
                                                    variants:
                                                        currentProduct.axis,
                                                  );
                                                },
                                                barrierColor: Colors.black
                                                    .withOpacity(0.8),
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
                              if (currentProduct.addition.isNotEmpty)
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
                                                        currentProduct.addition,
                                                  );
                                                },
                                                barrierColor: Colors.black
                                                    .withOpacity(0.8),
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
                        // TODO(info): везде на синие кнопки загрузку ставить
                        builder: (_, areFieldsValid) => BlueButtonWithText(
                          icon: isUpdating ? const UiCircleLoader() : null,
                          text: isUpdating
                              ? ''
                              : widget.isEditing
                                  ? 'Сохранить'
                                  : 'Добавить',
                          onPressed: areFieldsValid
                              ? () async {
                                  if (!isUpdating) {
                                    setState(() {
                                      isUpdating = true;
                                    });
                                    await wm.onAcceptPressed(
                                      isEditing: widget.isEditing,
                                    );
                                    setState(() {
                                      isUpdating = false;
                                    });
                                  }
                                }
                              : null,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: const [
          BottomInfoBlock(),
        ],
      ),
    );
  }
}
