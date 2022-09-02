import 'package:bausch/sections/profile/content/models/notification_model.dart';
import 'package:bausch/sections/profile/content/wm/notifications_wm.dart';
import 'package:bausch/static/static_data.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';
import 'package:visibility_detector/visibility_detector.dart';

class NotificationSection extends CoreMwwmWidget<NotificationsWM> {
  NotificationSection({
    required List<NotificationModel> items,
    Key? key,
  }) : super(
          widgetModelBuilder: (_) {
            return NotificationsWM(items: items);
          },
          key: key,
        );

  @override
  WidgetState<CoreMwwmWidget<NotificationsWM>, NotificationsWM>
      createWidgetState() => _NotificationSectionState();
}

class _NotificationSectionState
    extends WidgetState<NotificationSection, NotificationsWM> {
  @override
  Widget build(BuildContext context) {
    return StreamedStateBuilder<List<Widget>>(
      streamedState: wm.widgetslist,
      builder: (_, list) {
        return SliverPadding(
          padding:
              const EdgeInsets.symmetric(horizontal: StaticData.sidePadding),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, index) {
                return list[index];
              },
              childCount: list.length,
            ),
          ),
        );
      },
    );
  }
}
