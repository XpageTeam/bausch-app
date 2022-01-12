import 'package:bausch/models/catalog_item/product_item_model.dart';
import 'package:bausch/models/catalog_item/webinar_item_model.dart';
import 'package:bausch/sections/profile/content/models/base_order_model.dart';
import 'package:bausch/sections/profile/content/models/product_model.dart';
import 'package:bausch/sections/profile/content/models/webinar_model.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/catalog_item/catalog_item_widget.dart';
import 'package:flutter/material.dart';

class OrdersSection extends StatelessWidget {
  final List<BaseOrderModel?> ordersList;

  const OrdersSection({
    required this.ordersList,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint(ordersList.length.toString());

    return SliverPadding(
      padding: const EdgeInsets.symmetric(
        horizontal: StaticData.sidePadding,
      ),
      sliver: ordersList.isNotEmpty
          ? SliverToBoxAdapter(
              child: Column(
                children: List.generate(ordersList.length, (index) {
                  final order = ordersList[index];

                  switch (order?.category) {
                    case 'webinar':
                      order as WebinarOrderModel;

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
                          orderTitle:
                              'Заказ №${order.id} от ${order.formatedDate}',
                        ),
                      );

                    case 'product':
                      order as ProductOrderModel;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 4),
                        child: CatalogItemWidget(
                          model: ProductItemModel(
                            id: order.id,
                            name: order.title,
                            previewText: '',
                            detailText: '',
                            picture: order.product.imageLink,
                            price: order.price,
                          ),
                          deliveryInfo: order.status,
                          orderTitle:
                              'Заказ №${order.id} от ${order.formatedDate}',
                        ),
                      );

                    default:
                      return Container();
                  }
                }),
              ),
            )
          : SliverList(
              delegate: SliverChildListDelegate([
                Center(
                  child: Text(
                    'История заказов пуста :(',
                    textAlign: TextAlign.center,
                    style: AppStyles.p1Grey,
                  ),
                ),
              ]),
            ),
    );
  }
}
