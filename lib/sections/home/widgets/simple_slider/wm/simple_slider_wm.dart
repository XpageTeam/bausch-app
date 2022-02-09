import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class SimpleSliderWM extends WidgetModel {
  final lastItemState = StreamedState<int>(0);
  SimpleSliderWM() : super(const WidgetModelDependencies());
}
