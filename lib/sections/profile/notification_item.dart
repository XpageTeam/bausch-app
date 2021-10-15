import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/button_with_points_content.dart';
import 'package:flutter/material.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({Key? key}) : super(key: key);

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
              children: const [
                AutoSizeText(
                  'Регистрация в программе лояльности',
                  style: AppStyles.p1,
                  maxLines: 3,
                ),
                SizedBox(
                  height: 2,
                ),
                AutoSizeText(
                  '29.06.2021',
                  style: AppStyles.p1Grey,
                  maxLines: 3,
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          const ButtonContent(price: '+500'),
        ],
      ),
    );
  }
}
