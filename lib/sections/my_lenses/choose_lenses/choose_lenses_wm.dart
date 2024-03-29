// ignore_for_file: avoid_catches_without_on_clauses

import 'dart:async';

import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/main.dart';
import 'package:bausch/models/my_lenses/lens_product_list_model.dart';
import 'package:bausch/models/my_lenses/lenses_pair_model.dart';
import 'package:bausch/sections/my_lenses/choose_lenses/choose_product_sheet.dart';
import 'package:bausch/sections/my_lenses/my_lenses_wm.dart';
import 'package:bausch/sections/my_lenses/requesters/choose_lenses_requester.dart';
import 'package:bausch/sections/sheets/sheet.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/widgets/default_notification.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class ChooseLensesWM extends WidgetModel {
  final BuildContext context;
  final leftPair = StreamedState<PairModel>(
    PairModel(
      diopters: null,
      cylinder: null,
      axis: null,
      addition: null,
      basicCurvature: null,
    ),
  );
  final rightPair = StreamedState<PairModel>(
    PairModel(
      diopters: null,
      cylinder: null,
      axis: null,
      addition: null,
      basicCurvature: null,
    ),
  );
  final areFieldsValid = StreamedState(false);
  final isLeftEqual = StreamedState(false);

  final currentProduct = StreamedState<LensProductModel?>(null);
  final allDataEntityState = EntityStreamedState<bool>();

  final ChooseLensesRequester chooseLensesRequester = ChooseLensesRequester();
  final LensesPairModel? editLensPairModel;
  final MyLensesWM? myLensesWM;
  LensProductModel? oldProduct;
  LensProductModel? productBausch;
  LensProductListModel lensProductList = LensProductListModel(
    products: [],
  );

  ChooseLensesWM({
    required this.context,
    this.editLensPairModel,
    this.productBausch,
    this.myLensesWM,
  }) : super(const WidgetModelDependencies());

  @override
  void onBind() {
    if (productBausch != null) {
      currentProduct.accept(productBausch);
    }
    loadAllData();
    if (editLensPairModel != null &&
        editLensPairModel!.left.addition == editLensPairModel!.right.addition &&
        editLensPairModel!.left.axis == editLensPairModel!.right.axis &&
        editLensPairModel!.left.cylinder == editLensPairModel!.right.cylinder &&
        editLensPairModel!.left.diopters == editLensPairModel!.right.diopters &&
        editLensPairModel!.left.basicCurvature ==
            editLensPairModel!.right.basicCurvature) {
      isLeftEqual.accept(true);
    }

    currentProduct.bind((data) {
      AppsflyerSingleton.sdk.logEvent('my-lenses-add', <String, dynamic>{
        'id': data?.id,
        'bauschProdID': data?.bauschProductId,
        'name': data?.name,
      });

      AppMetrica.reportEventWithMap('my-lenses-add', data != null ?<String, Object>{
        'id': data.id,
        if (data.bauschProductId != null)
          'bauschProdID': data.bauschProductId!,
        'name': data.name,
      } : null);
    });
    super.onBind();
  }

  Future loadAllData() async {
    unawaited(allDataEntityState.loading());
    try {
      lensProductList = await chooseLensesRequester.loadLensProducts();
      if (editLensPairModel != null) {
        oldProduct = editLensPairModel!.product;
        await currentProduct.accept(editLensPairModel!.product);
        await leftPair.accept(editLensPairModel!.left);
        await rightPair.accept(editLensPairModel!.right);
        await areFieldsValid.accept(true);
      }
      unawaited(allDataEntityState.content(true));
    } catch (e) {
      showDefaultNotification(
        title: 'Произошла ошибка загрузки данных',
      );
      unawaited(
        allDataEntityState.error(
          const CustomException(
            title: 'Произошла ошибка загрузки данных',
          ),
        ),
      );
      lensProductList = LensProductListModel(products: []);
    }
  }

  Future validateFields() async {
    if (isLeftEqual.value) {
      await leftPair.accept(
        PairModel(
          basicCurvature: rightPair.value.basicCurvature,
          diopters: rightPair.value.diopters,
          cylinder: rightPair.value.cylinder,
          axis: rightPair.value.axis,
          addition: rightPair.value.addition,
        ),
      );
    }

    await areFieldsValid.accept(currentProduct.value != null &&
        (currentProduct.value!.diopters.isEmpty ||
            rightPair.value.diopters != null) &&
        (currentProduct.value!.basicCurvature.isEmpty ||
            rightPair.value.basicCurvature != null) &&
        (currentProduct.value!.cylinder.isEmpty ||
            rightPair.value.cylinder != null) &&
        (currentProduct.value!.axis.isEmpty || rightPair.value.axis != null) &&
        (currentProduct.value!.addition.isEmpty ||
            rightPair.value.addition != null) &&
        (currentProduct.value!.diopters.isEmpty ||
            leftPair.value.diopters != null) &&
        (currentProduct.value!.basicCurvature.isEmpty ||
            leftPair.value.basicCurvature != null) &&
        (currentProduct.value!.cylinder.isEmpty ||
            leftPair.value.cylinder != null) &&
        (currentProduct.value!.axis.isEmpty || leftPair.value.axis != null) &&
        (currentProduct.value!.addition.isEmpty ||
            leftPair.value.addition != null));
  }

  Future changeEyesEquality({required bool areEqual}) async {
    await isLeftEqual.accept(areEqual);
    if (isLeftEqual.value) {
      await leftPair.accept(
        PairModel(
          basicCurvature: rightPair.value.basicCurvature,
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
      bottomSheetColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.8),
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
    await leftPair.accept(PairModel(
      diopters: null,
      cylinder: null,
      axis: null,
      addition: null,
      basicCurvature: null,
    ));
    await rightPair.accept(PairModel(
      diopters: null,
      cylinder: null,
      axis: null,
      addition: null,
      basicCurvature: null,
    ));
    await isLeftEqual.accept(false);
    await areFieldsValid.accept(false);
  }

  Future onAcceptPressed({required bool isEditing}) async {
    unawaited(areFieldsValid.accept(false));
    try {
      if (isEditing) {
        if (oldProduct?.id != currentProduct.value!.id) {
          await chooseLensesRequester.addLensPair(
            lensesPairModel:
                LensesPairModel(left: leftPair.value, right: rightPair.value),
            productId: currentProduct.value!.id,
          );
        } else {
          await chooseLensesRequester.updateLensPair(
            lensesPairModel:
                LensesPairModel(left: leftPair.value, right: rightPair.value),
            productId: currentProduct.value!.id,
            pairId: editLensPairModel!.id!,
          );
        }
        Keys.mainContentNav.currentState!.pop();
      } else {
        await chooseLensesRequester.addLensPair(
          lensesPairModel:
              LensesPairModel(left: leftPair.value, right: rightPair.value),
          productId: currentProduct.value!.id,
        );
        await Keys.mainContentNav.currentState!
            .pushReplacementNamed('/my_lenses', arguments: [myLensesWM]);
      }
    } catch (e) {
      debugPrint('onAcceptPressed $e');
    }
    unawaited(areFieldsValid.accept(true));
  }

  int detectStartId(List<String> list) {
    var id = 0;
    var count = 0;
    final firstSign = list[0][0];
    if (firstSign != '+' && firstSign != '-') {
      return 0;
    }
    final breakSign = firstSign == '+' ? '-' : '+';
    for (final element in list) {
      final currentElement = element.replaceAll(' ', '');
      if (currentElement[0] != firstSign) {
        if (currentElement[0] == breakSign && count != 0) {
          id = count - 1;
        } else {
          id = count;
        }
        break;
      }
      count++;
    }
    return id;
  }
}
