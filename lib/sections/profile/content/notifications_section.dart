// ignore_for_file: avoid_unnecessary_containers

import 'package:bausch/sections/profile/content/models/notification_model.dart';
import 'package:bausch/sections/profile/notification_item.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/widgets/offers/offer_type.dart';
import 'package:bausch/widgets/offers/offers_section.dart';
import 'package:flutter/material.dart';

class NotificationSection extends StatelessWidget {
  final int groupChecked;
  final List<NotificationModel> items;
  final void Function(int groupChecked)? onChanged;

  const NotificationSection({
    required this.groupChecked,
    required this.items,
    this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final banners = Container(
      child: OffersSection(
        type: OfferType.notificationsScreen,
        showLoader: false,
        margin: const EdgeInsets.only(bottom: 4),
      ),
    );

    final List<Widget> notificationsList = items.map((item) {
      return Container(
        margin: const EdgeInsets.only(
          bottom: 4,
        ),
        child: NotificationItem(data: item),
      );
    }).toList();

    if (notificationsList.length < 5) {
      notificationsList.add(banners);
    } else {
      notificationsList.insert(2, banners);
    }

    // CustomRadio(
    //       value: 0,
    //       groupValue: groupChecked,
    //       text: 'Все уведомления',
    //       onChanged: (v) {
    //         onChanged?.call(0);
    //       },
    //     ),
    //     CustomRadio(
    //       value: 1,
    //       groupValue: groupChecked,
    //       text: 'История баллов',
    //       onChanged: (v) {
    //         onChanged?.call(1);
    //       },
    //     ),
    //     const SizedBox(
    //       height: 40,
    //     ),

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: StaticData.sidePadding),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (_, index) {
            return notificationsList[index];
          },
          childCount: notificationsList.length,
        ),
      ),
    );
  }
}
