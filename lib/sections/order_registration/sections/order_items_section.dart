import 'package:bausch/models/catalog_item/product_item_model.dart';
import 'package:bausch/sections/order_registration/widgets/order_item.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class OrderItemsSection extends StatelessWidget {
  final ProductItemModel model;
  final int points;
  const OrderItemsSection({
    required this.model,
    required this.points,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //* Список заказанных продуктов
          OrderItem(
            model: model,
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            'После оформления заказа у вас останется $points баллов',
            style: AppStyles.p1,
          ),
        ],
      ),
    );
  }
}
