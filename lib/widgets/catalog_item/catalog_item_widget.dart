import 'package:bausch/models/catalog_item/catalog_item_model.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/point_widget.dart';
import 'package:flutter/material.dart';

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
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
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
                              model.price.toString(),
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
                      if (address != null)
                        Flexible(
                          child: Container(
                            margin: const EdgeInsets.only(top: 2),
                            child: Text(
                              address!,
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
                    'assets/items/item1.png', //! model.img
                    scale: 3,
                  ),
                ),
              ],
            ),

            //* Информация о доставке
            if (deliveryInfo != null)
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
                              text: deliveryInfo,
                              style: AppStyles.p1Grey,
                            ),
                          ],
                        ),
                      ),
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
