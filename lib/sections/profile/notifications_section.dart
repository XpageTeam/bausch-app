import 'package:bausch/sections/profile/notification_item.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/test/models.dart';
import 'package:bausch/widgets/catalog_item/catalog_item_widget.dart';
import 'package:flutter/material.dart';

class NotificationSection extends StatelessWidget {
  const NotificationSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: StaticData.sidePadding),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => const Padding(
            padding: EdgeInsets.only(bottom: 4),
            child: NotificationItem(),
          ),
          childCount: 2,
        ),
      ),
    );
  }
}
