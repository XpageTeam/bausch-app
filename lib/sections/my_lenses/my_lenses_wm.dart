import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

enum MyLensesPage { currentLenses, oldLenses }

extension ShopsContentTypeAsString on MyLensesPage {
  String get asString =>
      this == MyLensesPage.currentLenses ? 'Ношу сейчас' : 'Были раньше';
}

class MyLensesWM extends WidgetModel {
  final BuildContext context;
  final switchAction = StreamedAction<MyLensesPage>();
  final historyList = ['5 май, 16:00', '6 май, 16:00', '7 май, 16:00'];
  final currentPageStreamed =
      StreamedState<MyLensesPage>(MyLensesPage.currentLenses);

  MyLensesWM({required this.context}) : super(const WidgetModelDependencies());

  @override
  void onBind() {
    switchAction.bind(
      (newType) => _switchPage(newType!),
    );
    super.onBind();
  }

  void _switchPage(MyLensesPage newPage) {
    if (currentPageStreamed.value != newPage) {
      currentPageStreamed.accept(newPage);
    }
  }
}
