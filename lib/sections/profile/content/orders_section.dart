import 'package:bausch/models/catalog_item/webinar_item_model.dart';
import 'package:bausch/sections/profile/content/models/base_order_model.dart';
import 'package:bausch/sections/profile/content/models/webinar_model.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/widgets/catalog_item/catalog_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrdersSection extends StatelessWidget {
  final List<BaseOrderModel?> ordersList;

  const OrdersSection({
    required this.ordersList,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(
        horizontal: StaticData.sidePadding,
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (_, index) {
            final order = ordersList[index];

            if (order == null) return null;

            if (order.category == 'webinar') {
              order as WebinarOrderModel;
              final orderDate = DateFormat('dd.MM.yyyy').format(order.date);

              return Container(
                margin: const EdgeInsets.only(bottom: 4),
                child: CatalogItemWidget(
                  model: WebinarItemModel(
                    availability: true,
                    isBought: true,
                    videoId: order.videoList,
                    id: order.id,
                    name: order.title,
                    previewText: '',
                    detailText: '',
                    picture: '',
                    price: order.price,
                  ),
                  deliveryInfo: order.status,
                  orderTitle: 'Заказ №${order.id} от $orderDate',
                ),
              );
            }

            return null;
          },
          childCount: ordersList.length,
        ),
      ),
    );
  }
}
