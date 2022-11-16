import 'package:bausch/help/utils.dart';
import 'package:bausch/models/catalog_item/partners_item_model.dart';
import 'package:bausch/models/catalog_item/product_item_model.dart';
import 'package:bausch/models/catalog_item/webinar_item_model.dart';
import 'package:bausch/models/sheets/simple_sheet_model.dart';
import 'package:bausch/sections/profile/content/discount_info_sheet_body.dart';
import 'package:bausch/sections/profile/content/models/base_order_model.dart';
import 'package:bausch/sections/profile/content/models/certificate_model.dart';
import 'package:bausch/sections/profile/content/models/consultation_model.dart';
import 'package:bausch/sections/profile/content/models/offline_order_model.dart';
import 'package:bausch/sections/profile/content/models/partner_model.dart';
import 'package:bausch/sections/profile/content/models/product_model.dart';
import 'package:bausch/sections/profile/content/models/webinar_model.dart';
import 'package:bausch/sections/sheets/sheet_methods.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/catalog_item/catalog_item_widget.dart';
import 'package:bausch/widgets/default_notification.dart';
import 'package:bausch/widgets/simple_webview_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
                  final category = order?.category;

                  switch (category) {
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
                            disclaimer: '',
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
                          bottomWidget: order.address != null ||
                                  order.phone != null
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (order.address != null)
                                        Row(
                                          children: [
                                            Image.asset(
                                              'assets/icons/map-marker.png',
                                              height: 16,
                                            ),
                                            const SizedBox(
                                              width: 6,
                                            ),
                                            Flexible(
                                              child: Text(
                                                order.address!,
                                                style: AppStyles.p1,
                                              ),
                                            ),
                                          ],
                                        ),
                                      if (order.phone != null)
                                        Padding(
                                          padding: EdgeInsets.only(
                                            top: order.address != null
                                                ? 10.0
                                                : 0,
                                          ),
                                          child: GestureDetector(
                                            onTap: () => Utils.launchUrl(
                                              rawUrl: order.phone!,
                                              isPhone: true,
                                            ),
                                            child: Text(
                                              order.phone!,
                                              style: AppStyles.p1.copyWith(
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                )
                              : null,
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
                            disclaimer: '',
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

                      final isOffline = category == 'offline';
                      return GestureDetector(
                        onTap: () {
                          ProductModelDetailLoader.load(
                            order.product.id,
                            before: () => showLoader(context),
                            onSuccess: (product) {
                              bool? hasLoadingRoute;
                              Navigator.of(Keys.mainNav.currentContext!)
                                  .popUntil(
                                (route) {
                                  debugPrint(
                                    'route.settings.name: ${route.settings.name}',
                                  );
                                  hasLoadingRoute ??=
                                      route.settings.name == 'LoadingRoute';
                                  return route.settings.name != 'LoadingRoute';
                                },
                              );
                              if (hasLoadingRoute!) {
                                showSheet<DiscountInfoSheetBodyArgs>(
                                  context,
                                  SimpleSheetModel(
                                    name: 'discount_info',
                                    type: 'discount_info',
                                  ),
                                  DiscountInfoSheetBodyArgs(
                                    title: order.title,
                                    code: order.coupon.code,
                                    date: DateFormat('dd MMM yyyy', 'ru_RUS')
                                        .format(
                                      order.promocodeDateTime!,
                                    ),
                                    type: order.category,
                                    productModelDetail: product,
                                    link: order.link,
                                  ),
                                );
                              }
                            },
                            onError: () {
                              Keys.mainNav.currentState!.pop();
                              showDefaultNotification(
                                title: 'Не удалось загрузить продукт',
                              );
                            },
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 4),
                          child: CatalogItemWidget(
                            promocodeDate: order.promocodeDate,
                            bottomWidget: order.link != null &&
                                    order.link!.isNotEmpty
                                ? Align(
                                    alignment: Alignment.centerLeft,
                                    child: GestureDetector(
                                      onTap: () => openSimpleWebView(
                                        context,
                                        url: order.link!,
                                      ),
                                      child: Container(
                                        margin: const EdgeInsets.only(top: 16),
                                        color: Colors.transparent,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Image.asset(
                                              isOffline
                                                  ? 'assets/icons/website.png'
                                                  : 'assets/icons/basket.png',
                                              height: 16,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              isOffline
                                                  ? 'На сайт оптики'
                                                  : 'В интернет магазин',
                                              style: AppStyles.p1.copyWith(
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : null,
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
