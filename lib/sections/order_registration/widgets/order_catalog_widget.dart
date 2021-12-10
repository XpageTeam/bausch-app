import 'package:bausch/models/order_registration/order_item.dart';
import 'package:bausch/test/models.dart';
import 'package:bausch/widgets/catalog_item/catalog_item_widget.dart';
import 'package:flutter/material.dart';

class OrderCatalogWidget extends StatelessWidget {
  final List<OrderItem> orderItemList;
  const OrderCatalogWidget({
    required this.orderItemList,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) => CatalogItemWidget(
        model: Models.items[0],
        orderTitle: 'Заказ № 89088 от 29.06.2021',
        address: 'Aдрес: г. Москва, ул. Задарожная, д. 20, к. 2 ',
        deliveryInfo: '5 дней до получения',
      ),
      separatorBuilder: (context, index) => const SizedBox(height: 4),
      itemCount: 1,
    );
  }
}
