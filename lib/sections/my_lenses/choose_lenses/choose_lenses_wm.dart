import 'package:bausch/models/my_lenses/lens_product_list_model.dart';
import 'package:bausch/sections/my_lenses/requesters/choose_lenses_requester.dart';
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
  late final LensProductListModel lensProductList;
  final ChooseLensesRequester chooseLensesRequester = ChooseLensesRequester();

  ChooseLensesWM({required this.context})
      : super(const WidgetModelDependencies());

  @override
  void onBind() {
    loadAllData();
    super.onBind();
  }

  Future loadAllData() async {
    try {
      lensProductList = await chooseLensesRequester.loadLensProducts();
      // ignore: avoid_catches_without_on_clauses
    } catch (_) {
      lensProductList = LensProductListModel(products: []);
    }
  }

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
