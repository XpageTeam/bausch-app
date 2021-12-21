import 'package:bausch/models/catalog_item/product_item_model.dart';
import 'package:bausch/sections/order_registration/widget_models/order_registration_screen_wm.dart';
import 'package:bausch/sections/order_registration/widgets/order_item.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderItemsSection extends StatefulWidget {
  // final ProductItemModel model;
  // final int points;
  const OrderItemsSection({
    // required this.model,
    // required this.points,
    Key? key,
  }) : super(key: key);

  @override
  State<OrderItemsSection> createState() => _OrderItemsSectionState();
}

class _OrderItemsSectionState extends State<OrderItemsSection> {
  late OrderRegistrationScreenWM wm;

  @override
  void initState() {
    super.initState();

    wm = Provider.of<OrderRegistrationScreenWM>(
      context,
      listen: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //* Список заказанных продуктов
          OrderItem(
            model: wm.productItemModel,
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            'После оформления заказа у вас останется ${wm.difference} баллов',
            style: AppStyles.p1,
          ),
        ],
      ),
    );
  }
}
