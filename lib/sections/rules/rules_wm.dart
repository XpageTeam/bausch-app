import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class RulesWM extends WidgetModel {
  final colorState = StreamedState<Color>(Colors.white);

  BuildContext context;

  RulesWM({
    required this.context,
  }) : super(const WidgetModelDependencies());
}
