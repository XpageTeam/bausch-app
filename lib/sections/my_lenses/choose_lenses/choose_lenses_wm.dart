import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class ChooseLensesWM extends WidgetModel {
  final BuildContext context;

  // TODO(pavlov): добавить валидацию продукта

  final rightDiopters = StreamedState<String?>(null);
  final rightCylinder = StreamedState<String?>(null);
  final rightAxis = StreamedState<String?>(null);
  final rightAddidations = StreamedState<String?>(null);

  final leftDiopters = StreamedState<String?>(null);
  final leftCylinder = StreamedState<String?>(null);
  final leftAxis = StreamedState<String?>(null);
  final leftAddidations = StreamedState<String?>(null);
  final areFieldsValid = StreamedState(false);
  final isLeftEqual = StreamedState(false);

  ChooseLensesWM({required this.context})
      : super(const WidgetModelDependencies());

  Future validateFields() async {
    if (isLeftEqual.value) {
      await leftDiopters.accept(rightDiopters.value);
      await leftCylinder.accept(rightCylinder.value);
      await leftAxis.accept(rightAxis.value);
      await leftAddidations.accept(rightAddidations.value);
    }
    await areFieldsValid.accept(rightDiopters.value != null &&
        rightCylinder.value != null &&
        rightAxis.value != null &&
        rightAddidations.value != null &&
        leftDiopters.value != null &&
        leftCylinder.value != null &&
        leftAxis.value != null &&
        leftAddidations.value != null);
  }

  Future changeEyesEquality({required bool areEqual}) async {
    await isLeftEqual.accept(areEqual);
    if (isLeftEqual.value) {
      await leftDiopters.accept(rightDiopters.value);
      await leftCylinder.accept(rightCylinder.value);
      await leftAxis.accept(rightAxis.value);
      await leftAddidations.accept(rightAddidations.value);
    }
  }
}
