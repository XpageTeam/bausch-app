import 'package:bausch/models/catalog_item_model.dart';
import 'package:bausch/sections/sheets/screens/discount_optics/final_discount_optics.dart';
import 'package:bausch/sections/sheets/screens/free_packaging/final_free_packaging.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/test/models.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/point_widget.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';

enum ItemType { product, promocode, webinar }

class CatalogItemWidget extends StatelessWidget {
  final CatalogItemModel model;
  final String? orderTitle;
  final String? address;
  final String? deliveryInfo;

  const CatalogItemWidget({
    required this.model,
    this.orderTitle,
    this.address,
    this.deliveryInfo,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: model.type == ItemType.product ? 20 : 12,
          horizontal: 12,
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //* Название заказа
                      if (orderTitle != null)
                        Flexible(
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 2),
                            child: Text(
                              orderTitle!,
                              style: AppStyles.p1Grey,
                            ),
                          ),
                        ),

                      //* Название товара
                      Flexible(
                        child: Text(
                          model.name,
                          style: AppStyles.h2Bold,
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),

                      //* Цена и виджет баллов
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              model.price,
                              style: AppStyles.h2Bold,
                            ),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          const PointWidget(),
                        ],
                      ),

                      //* Адрес
                      if (model.address != null)
                        Flexible(
                          child: Container(
                            margin: const EdgeInsets.only(top: 2),
                            child: Text(
                              model.address!,
                              style: AppStyles.p1Grey,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                //* Изображение товара
                Expanded(
                  child: Image.asset(
                    model.type != ItemType.product
                        ? 'assets/offers-from-partners.png'
                        : 'assets/items/item1.png', //! model.img
                    scale: 3,
                  ),
                ),
              ],
            ),

            //* Информация о доставке
            if (model.deliveryInfo != null)
              Container(
                margin: const EdgeInsets.only(top: 32),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.battery_charging_full,
                      color: AppTheme.mineShaft,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Flexible(
                      child: Text.rich(
                        TextSpan(
                          text: 'Ещё пару дней. ',
                          style: AppStyles.p1,
                          children: [
                            TextSpan(
                              text: model.deliveryInfo,
                              style: AppStyles.p1Grey,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (model.type == ItemType.promocode)
              GestureDetector(
                onTap: () {
                  showFlexibleBottomSheet<void>(
                    context: Keys.mainNav.currentContext!,
                    minHeight: 0,
                    initHeight: 0.7,
                    maxHeight: 0.95,
                    anchors: [0, 0.6, 0.95],
                    builder: (context, controller, d) {
                      return FinalDiscountOptics(
                        controller: controller,
                        model: Models.items[0],
                      );
                    },
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.mystic,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '6СС5165АDF345',
                        style: AppStyles.h2,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Image.asset(
                        'assets/copy.png',
                        height: 16,
                      ),
                    ],
                  ),
                ),
              ),
            if (model.type == ItemType.webinar)
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.mystic,
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Перейти к просмотру',
                      style: AppStyles.h2,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
