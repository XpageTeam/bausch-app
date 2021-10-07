import 'package:bausch/models/order_registration/order_item.dart';
import 'package:bausch/sections/order_registration/widgets/order_item_widget.dart';
import 'package:flutter/material.dart';

class OrderItemListWidget extends StatelessWidget {
  final List<OrderItem> orderItemList;
  const OrderItemListWidget({
    required this.orderItemList,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: orderItemList.fold<List<Widget>>(
        [],
        (orderListWiget, orderItem) {
          orderListWiget.add(
            OrderItemWidget(
              title: orderItem.title,
              points: orderItem.points,
              imgLink: orderItem.imgLink,
            ),
          );
          if (orderItem != orderItemList.last) {
            orderListWiget.add(
              const SizedBox(height: 4),
            );
          }
          return orderListWiget;
        },
      ),
    );
  }
}

