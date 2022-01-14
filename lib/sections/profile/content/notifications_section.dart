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
      ),
    );

    final List<Widget> notificationsList = items.map((item) {
      return Container(child: NotificationItem(data: item));
    }).toList();

    if (notificationsList.length < 5) {
      notificationsList.add(banners);
    } else {
      notificationsList.insert(2, banners);
    }

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(
        StaticData.sidePadding,
        20,
        StaticData.sidePadding,
        0,
      ),
      sliver: SliverToBoxAdapter(
        child: Column(
          children: [
            // TODO(Danil): Гоша должен доделать
            // CustomRadio(
            //   value: 0,
            //   groupValue: groupChecked,
            //   text: 'Все уведомления',
            //   onChanged: (v) {
            //     onChanged?.call(0);
            //   },
            // ),
            // CustomRadio(
            //   value: 1,
            //   groupValue: groupChecked,
            //   text: 'История баллов',
            //   onChanged: (v) {
            //     onChanged?.call(1);
            //   },
            // ),
            // const SizedBox(
            //   height: 40,
            // ),
            ListView.separated(
              itemBuilder: (_, index) {
                return notificationsList[index];
              },
              separatorBuilder: (_, __) => const SizedBox(height: 4),
              itemCount: notificationsList.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
            ),
            OffersSection(
              type: OfferType.notificationsScreen,
            ),
          ],
        ),
      ),
    );
  }
}
