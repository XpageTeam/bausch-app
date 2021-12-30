import 'package:bausch/sections/profile/notification_item.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/widgets/offers/offer_type.dart';
import 'package:bausch/widgets/offers/offers_section.dart';
import 'package:bausch/widgets/select_widgets/custom_radio.dart';
import 'package:flutter/material.dart';

class NotificationSection extends StatelessWidget {
  final int groupChecked;
  final void Function(int groupChecked)? onChanged;
  const NotificationSection({
    required this.groupChecked,
    this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            CustomRadio(
              value: 0,
              groupValue: groupChecked,
              text: 'Все уведомления',
              onChanged: (v) {
                onChanged?.call(0);
              },
            ),
            CustomRadio(
              value: 1,
              groupValue: groupChecked,
              text: 'История баллов',
              onChanged: (v) {
                onChanged?.call(1);
              },
            ),
            const SizedBox(
              height: 40,
            ),
            ...List.generate(
              4,
              (index) => const Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: NotificationItem(),
              ),
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
