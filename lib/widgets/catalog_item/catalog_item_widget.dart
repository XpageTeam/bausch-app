import 'package:bausch/models/catalog_item/catalog_item_model.dart';
import 'package:bausch/models/catalog_item/partners_item_model.dart';
import 'package:bausch/models/catalog_item/product_item_model.dart';
import 'package:bausch/models/catalog_item/promo_item_model.dart';
import 'package:bausch/models/catalog_item/webinar_item_model.dart';
import 'package:bausch/static/static_data.dart';
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

  //TODO(Nikita) : Добавить блок с промокодом, где нужно
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          StaticData.sidePadding,
          20,
          StaticData.sidePadding,
          (model is ProductItemModel) ? 20 : 12,
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
                              model.price.toString(),
                              style: AppStyles.h2Bold,
                            ),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          PointWidget(textStyle: AppStyles.h2),
                        ],
                      ),

                      //* Адрес
                      if (model is ProductItemModel)
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
                    img(model), //! model.img
                    scale: 3,
                  ),
                ),
              ],
            ),

            //* Информация о доставке
            if (model is ProductItemModel)
              Container(
                margin: const EdgeInsets.only(top: 32),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/substract.png',
                      height: 15,
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
            if (model is! ProductItemModel)
              GreyButton(
                text: txt(model),
              ),
          ],
        ),
      ),
    );
  }

  //* Вывод нужной картинки в зависимости от типа элемента
  String img(CatalogItemModel _model) {
    if (_model is WebinarItemModel) {
      return 'assets/webinar-recordings.png';
    } else if (_model is ProductItemModel) {
      return _model.picture;
    } else if (_model is PartnersItemModel) {
      return 'assets/offers-from-partners.png';
    } else {
      return 'assets/discount-in-optics.png';
    }
  }
}

//* Вывод нужной надписи в зависимости от типа элемента
String txt(CatalogItemModel _model) {
  if (_model is WebinarItemModel) {
    return 'Перейти к просмотру';
  } else if (_model is PartnersItemModel) {
    return _model.poolPromoCode;
  } else {
    return (_model as PromoItemModel).code;
  }
}

class GreyButton extends StatelessWidget {
  final String text;
  final String? icon;
  const GreyButton({
    required this.text,
    this.icon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
              text,
              style: AppStyles.h2,
            ),
            const SizedBox(
              width: 10,
            ),
            Image.asset(
              icon ?? 'assets/copy.png',
              height: 16,
            ),
          ],
        ),
      ),
    );
  }
}
