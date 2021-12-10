import 'package:bausch/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class ProfileScreenWM extends WidgetModel {
  final notificationStreamed =
      StreamedAction<DraggableScrollableNotification>();
  final colorStreamed = StreamedState<Color>(
    Color.alphaBlend(AppTheme.turquoiseBlue, AppTheme.mystic),
  );

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

        colorStreamed.accept(
          Color.alphaBlend(
            AppTheme.turquoiseBlue.withOpacity(1 - opacity),
            AppTheme.mystic,
          ),
        );
      },
    );
    super.onBind();
  }
}
