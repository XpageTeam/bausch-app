import 'package:bausch/models/my_lenses/lens_product_list_model.dart';
import 'package:bausch/models/my_lenses/lenses_pair_model.dart';
import 'package:bausch/packages/bottom_sheet/src/flexible_bottom_sheet_route.dart';
import 'package:bausch/sections/my_lenses/choose_lenses/choose_product_sheet.dart';
import 'package:bausch/sections/my_lenses/my_lenses_wm.dart';
import 'package:bausch/sections/my_lenses/requesters/choose_lenses_requester.dart';
import 'package:bausch/sections/my_lenses/requesters/my_lenses_requester.dart';
import 'package:bausch/sections/sheets/sheet.dart';
import 'package:bausch/static/static_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class ChooseLensesWM extends WidgetModel {
  final BuildContext context;
  final leftPair = StreamedState<PairModel>(
    PairModel(diopters: null, cylinder: null, axis: null, addition: null),
  );
  final rightPair = StreamedState<PairModel>(
    PairModel(diopters: null, cylinder: null, axis: null, addition: null),
  );
  final areFieldsValid = StreamedState(false);
  final isLeftEqual = StreamedState(false);
  late final LensProductListModel lensProductList;
  final currentProduct = StreamedState<LensProductModel?>(null);
  final ChooseLensesRequester chooseLensesRequester = ChooseLensesRequester();
  final MyLensesRequester myLensesRequester = MyLensesRequester();
  final LensesPairModel? editLensPairModel;

  ChooseLensesWM({required this.context, this.editLensPairModel})
      : super(const WidgetModelDependencies());

  @override
  void onBind() {
    loadAllData();
    if (editLensPairModel != null &&
        editLensPairModel!.left.addition == editLensPairModel!.right.addition &&
        editLensPairModel!.left.axis == editLensPairModel!.right.axis &&
        editLensPairModel!.left.cylinder == editLensPairModel!.right.cylinder &&
        editLensPairModel!.left.diopters == editLensPairModel!.right.diopters) {
      isLeftEqual.accept(true);
    }
    super.onBind();
  }

  Future loadAllData() async {
    try {
      lensProductList = await chooseLensesRequester.loadLensProducts();
      if (editLensPairModel != null) {
        await currentProduct.accept(
          await myLensesRequester.loadLensProduct(
            id: editLensPairModel!.productId!,
          ),
        );
        await leftPair.accept(editLensPairModel!.left);
        await rightPair.accept(editLensPairModel!.right);

        await areFieldsValid.accept(true);
      }
      // ignore: avoid_catches_without_on_clauses
    } catch (_) {
      lensProductList = LensProductListModel(products: []);
    }
  }

  Future validateFields() async {
    if (isLeftEqual.value) {
      await leftPair.accept(
        PairModel(
          diopters: rightPair.value.diopters,
          cylinder: rightPair.value.cylinder,
          axis: rightPair.value.axis,
          addition: rightPair.value.addition,
        ),
      );
    }
    await areFieldsValid.accept(rightPair.value.diopters != null &&
        rightPair.value.cylinder != null &&
        rightPair.value.axis != null &&
        rightPair.value.addition != null &&
        leftPair.value.diopters != null &&
        leftPair.value.cylinder != null &&
        leftPair.value.axis != null &&
        leftPair.value.addition != null &&
        currentProduct.value != null);
  }

  Future changeEyesEquality({required bool areEqual}) async {
    await isLeftEqual.accept(areEqual);
    if (isLeftEqual.value) {
      await leftPair.accept(
        PairModel(
          diopters: rightPair.value.diopters,
          cylinder: rightPair.value.cylinder,
          axis: rightPair.value.axis,
          addition: rightPair.value.addition,
        ),
      );
      await validateFields();
    }
  }

  Future showProductSheet(BuildContext context) async {
    await showFlexibleBottomSheet<void>(
      minHeight: 0,
      initHeight: 0.95,
      maxHeight: 0.95,
      anchors: [0, 0.6, 0.95],
      context: context,
      builder: (context, controller, d) {
        return SheetWidget(
          child: ChooseProductSheet(
            controller: controller,
            lensProductListModel: lensProductList,
            acceptProduct: currentProduct.accept,
          ),
          withPoints: false,
        );
      },
    );
    await validateFields();
  }

  Future onAcceptPressed({required bool isEditing}) async {
    if (isEditing) {
      await chooseLensesRequester.updateLensPair(
        lensesPairModel:
            LensesPairModel(left: leftPair.value, right: rightPair.value),
        productId: currentProduct.value!.id,
        pairId: editLensPairModel!.id!,
      );

      Keys.mainContentNav.currentState!.pop();
    } else {
      await chooseLensesRequester.addLensPair(
        lensesPairModel:
            LensesPairModel(left: leftPair.value, right: rightPair.value),
        productId: currentProduct.value!.id,
      );
      await Keys.mainContentNav.currentState!
          .pushReplacementNamed('/my_lenses', arguments: [MyLensesWM()]);
    }
  }
}