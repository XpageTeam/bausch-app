import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class ProfileScreenWM extends WidgetModel {
  final notificationStreamed =
      StreamedAction<DraggableScrollableNotification>();
  late final opacityStreamed = StreamedState<double>(opacity);

  double opacity = 0.0;

  ProfileScreenWM()
      : super(
          const WidgetModelDependencies(),
        );

  @override
  void onBind() {
    subscribe<DraggableScrollableNotification>(
      notificationStreamed.stream,
      (v) {
        opacity = (v.extent - v.minExtent) /
            (v.maxExtent - v.minExtent); // Нормализация значения от 0 до 1

        opacityStreamed.accept(opacity);
      },
    );
    super.onBind();
  }
}
