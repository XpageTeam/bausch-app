import 'package:bausch/sections/profile/content/models/notification_model.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/button_with_points_content.dart';
import 'package:flutter/material.dart';

class NotificationItem extends StatelessWidget {
  final NotificationModel data;

  const NotificationItem({required this.data, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  data.title,
                  style: AppStyles.p1,
                  // maxLines: 3,
                ),
                if (data.formatedDate != null)
                  Container(
                    margin: const EdgeInsets.only(top: 2),
                    child: Text(
                      data.formatedDate!,
                      style: AppStyles.p1Grey,
                      maxLines: 3,
                    ),
                  ),
                // TODO(pavlov): прочитано или нет
                Container(
                  margin: const EdgeInsets.only(top: 2),
                  child: Text(
                    data.read! ? 'Прочитано' : 'Не прочитано',
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
          if (data.points != null)
            ButtonContent(
              price: data.formatedPrice,
            ),
        ],
      ),
    );
  }
}
