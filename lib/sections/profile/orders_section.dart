import 'package:bausch/static/static_data.dart';
import 'package:bausch/test/models.dart';
import 'package:bausch/widgets/catalog_item/catalog_item_widget.dart';
import 'package:flutter/material.dart';

class OrdersSection extends StatelessWidget {
  const OrdersSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: StaticData.sidePadding),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: CatalogItemWidget(
              model: Models.items[index],
              orderTitle: 'Заказ № 89088 от 29.06.2021',
            ),
          ),
          childCount: Models.items.length,
        ),
      ),
    );
  }
}
