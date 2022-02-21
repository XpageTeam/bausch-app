import 'package:bausch/global/user/user_wm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class ProfileScreenWM extends WidgetModel {
  final BuildContext context;
  final profileAppBarHeight =
      58.0; //  это высота ProfileAppBar (56) + высота отступа (это в ProfileAppBar) сверху (2)
  final imageHeight = 220.0;
  final sizedBoxHeight = 17.0;

  final notificationStreamed =
      StreamedAction<DraggableScrollableNotification>();
  late final opacityStreamed = StreamedState<double>(opacity);

  double opacity = 0.0;

  late UserWM userWM;

  late double minChildSize;
  late double maxChildSize;

  ProfileScreenWM({
    required this.context,
  }) : super(
          const WidgetModelDependencies(),
        );
  @override
  void onLoad() {
    userWM = Provider.of<UserWM>(context, listen: false);

    super.onLoad();
  }

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

  void initDraggableChildSizes() {
    minChildSize = _calcMinChildSize();
    maxChildSize = _calcMaxChildSize();
  }

  void initMaxChildSize() {}
  double _calcMinChildSize() {
    return 1 -
        (imageHeight / 2 + sizedBoxHeight + profileAppBarHeight) /
            MediaQuery.of(context).size.height;
  }

  double _calcMaxChildSize() {
    return 1 -
        profileAppBarHeight /
            (MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top -
                MediaQuery.of(context).padding.bottom);
  }
}
