import 'package:bausch/models/catalog_item/partners_item_model.dart';
import 'package:bausch/models/catalog_item/product_item_model.dart';
import 'package:bausch/models/catalog_item/webinar_item_model.dart';
import 'package:bausch/sections/profile/content/models/base_order_model.dart';
import 'package:bausch/sections/profile/content/models/certificate_model.dart';
import 'package:bausch/sections/profile/content/models/consultation_model.dart';
import 'package:bausch/sections/profile/content/models/offline_order_model.dart';
import 'package:bausch/sections/profile/content/models/partner_model.dart';
import 'package:bausch/sections/profile/content/models/product_model.dart';
import 'package:bausch/sections/profile/content/models/webinar_model.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/catalog_item/catalog_item_widget.dart';
import 'package:flutter/material.dart';

class OrdersSection extends StatelessWidget {
  final List<BaseOrderModel?> ordersList;

  const OrdersSection({required this.ordersList, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(
        horizontal: StaticData.sidePadding,
      ),
      sliver: ordersList.isNotEmpty
          ? SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, index) {
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
                            videoIds: order.videoList,
                            id: order.id,
                            name: order.title,
                            previewText: '',
                            detailText: '',
                            picture: order.product.imageLink ?? '',
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
                          promocodeDate: order.promocodeDate,
                          model: ProductItemModel(
                            id: order.id,
                            name: order.title,
                            previewText: '',
                            detailText: '',
                            picture: order.product.imageLink,
                            price: order.price,
                          ),
                          deliveryInfo: order.status,
                          address: order.deliveryText,
                          orderTitle:
                              'Заказ №${order.id} от ${order.formatedDate}',
                        ),
                      );

                    case 'certificate':
                      order as CertificateOrderModel;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 4),
                        child: CatalogItemWidget(
                          promocodeDate: order.promocodeDate,
                          model: PartnersItemModel(
                            id: order.id,
                            name: order.title,
                            previewText: '',
                            detailText: '',
                            price: order.price,
                            poolPromoCode: order.coupon.code,
                            staticPromoCode: order.coupon.code,
                            picture: '',
                          ),
                          deliveryInfo: order.status,
                          orderTitle:
                              'Заказ №${order.id} от ${order.formatedDate}',
                        ),
                      );

                    case 'online_consultation':
                      order as ConsultationOrderModel;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 4),
                        child: CatalogItemWidget(
                          promocodeDate: order.promocodeDate,
                          model: ProductItemModel(
                            id: order.id,
                            name: order.title,
                            previewText: '',
                            detailText: '',
                            price: order.price,
                            picture: order.product.imageLink,
                          ),
                          deliveryInfo: order.status,
                          orderTitle:
                              'Заказ №${order.id} от ${order.formatedDate}',
                        ),
                      );

                    case 'partner':
                      order as PartnerOrderModel;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 4),
                        child: CatalogItemWidget(
                          promocodeDate: order.promocodeDate,
                          model: PartnersItemModel(
                            id: order.id,
                            name: order.title,
                            previewText: '',
                            detailText: '',
                            picture: order.product.imageLink,
                            price: order.price,
                            poolPromoCode: order.coupon.code,
                            staticPromoCode: order.coupon.code,
                          ),
                          deliveryInfo: order.status,
                          orderTitle:
                              'Заказ №${order.id} от ${order.formatedDate}',
                        ),
                      );

                    case 'offline':
                    case 'discount':
                      order as OfflineOrderModel;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 4),
                        child: CatalogItemWidget(
                          promocodeDate: order.promocodeDate,
                          model: PartnersItemModel(
                            id: order.id,
                            name: order.title,
                            previewText: '',
                            detailText: '',
                            picture: order.product.imageLink,
                            price: order.price,
                            poolPromoCode: order.coupon.code,
                            staticPromoCode: order.coupon.code,
                          ),
                          deliveryInfo: order.status,
                          orderTitle:
                              'Заказ №${order.id} от ${order.formatedDate}',
                        ),
                      );

                    default:
                      return Container();
                  }
                },
                childCount: ordersList.length,
              ),
            )
          : SliverList(
              delegate: SliverChildListDelegate([
                const Center(
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
