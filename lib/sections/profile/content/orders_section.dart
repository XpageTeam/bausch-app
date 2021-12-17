import 'package:bausch/static/static_data.dart';
import 'package:bausch/test/models.dart';
import 'package:bausch/widgets/catalog_item/catalog_item_widget.dart';
import 'package:flutter/material.dart';

class OrdersSection extends StatelessWidget {
  const OrdersSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          StaticData.sidePadding,
          40,
          StaticData.sidePadding,
          0,
        ),
        child: Column(
          children: List.generate(
            Models.items.length,
            (i) => Padding(
              padding: EdgeInsets.only(
                bottom: i != Models.items.length - 1 ? 4 : 0,
              ),
              child: CatalogItemWidget(
                model: Models.items[i],
                deliveryInfo: 'Eсли нет, пишите сюда, разберемся',
                orderTitle: 'Заказ № 89088 от 29.06.2021',
                address: 'Aдрес: г. Москва, ул. Задарожная, д. 20, к. 2 ',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
