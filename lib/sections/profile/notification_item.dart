import 'package:bausch/sections/profile/content/models/notification_model.dart';
import 'package:bausch/sections/profile/content/wm/notifications_wm.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/button_with_points_content.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';
import 'package:visibility_detector/visibility_detector.dart';

class NotificationItem extends StatelessWidget {
  final NotificationModel data;
  final NotificationsWM wm;

  const NotificationItem({required this.wm, required this.data, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamedStateBuilder<List<NotificationModel>>(
      streamedState: wm.notificationsReadList,
      builder: (_, list) {
        final item = list.firstWhere((element) => element.id == data.id);
        return VisibilityDetector(
          key: Key(data.id.toString()),
          onVisibilityChanged: (info) async {
            if (info.visibleFraction >= 0.8 && !item.read!) {
              wm.updatedNotificationIds.add(item.id);
              await wm.updateNotifications();
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: StaticData.sidePadding,
              vertical: 20,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: AppStyles.p1,
                        // maxLines: 3,
                      ),
                      if (item.formatedDate != null)
                        Container(
                          margin: const EdgeInsets.only(top: 2),
                          child: Text(
                            item.formatedDate!,
                            style: AppStyles.p1Grey,
                            maxLines: 3,
                          ),
                        ),
                      // TODO(pavlov): прочитано или нет
                      Container(
                        margin: const EdgeInsets.only(top: 2),
                        child: Text(
                          item.read! ? 'Прочитано' : 'Не прочитано',
                          style: AppStyles.p1Grey,
                          maxLines: 3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                if (item.points != null)
                  ButtonContent(
                    price: item.formatedPrice,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
