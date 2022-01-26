import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class BottomSheetWM extends WidgetModel {
  final colorState = StreamedState<Color>(Colors.white);

  final Color color;
  BottomSheetWM({required this.color}) : super(const WidgetModelDependencies());

  @override
  void onLoad() {
    colorState.accept(color);

    super.onLoad();
  }
}
