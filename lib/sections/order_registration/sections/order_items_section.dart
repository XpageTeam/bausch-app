import 'package:bausch/models/order_registration/order_item.dart';
import 'package:bausch/sections/order_registration/widgets/margin.dart';
import 'package:bausch/sections/order_registration/widgets/order_item_list_widget.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class OrderItemsSection extends StatelessWidget {
  final List<OrderItem> orderItemList;
  final int points;
  const OrderItemsSection({
    required this.orderItemList,
    this.points = 100,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Margin(
      margin: const EdgeInsets.only(bottom: 40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //* Список заказанных продуктов
          OrderItemListWidget(orderItemList: orderItemList),
          const SizedBox(
            height: 12,
          ),
          Text(
            'После совершения заказа у вас останется $points баллов',
            style: AppStyles.p1,
          ),
        ],
      ),
    );
  }
}
