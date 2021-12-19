// ignore_for_file: avoid-returning-widgets

import 'package:bausch/models/catalog_item/catalog_item_model.dart';
import 'package:bausch/models/catalog_item/partners_item_model.dart';
import 'package:bausch/models/catalog_item/product_item_model.dart';
import 'package:bausch/models/catalog_item/promo_item_model.dart';
import 'package:bausch/models/catalog_item/webinar_item_model.dart';
import 'package:bausch/sections/sheets/screens/discount_optics/discount_type.dart';
import 'package:bausch/sections/sheets/screens/discount_optics/final_discount_optics.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/123/default_notification.dart';
import 'package:bausch/widgets/point_widget.dart';
import 'package:bausch/widgets/webinar_popup/webinar_popup.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';

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
                              model.priceToString,
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
                      if (model is ProductItemModel && address != null)
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 30),
                            child: Container(
                              margin: const EdgeInsets.only(top: 2),
                              child: Text(
                                address!,
                                style: AppStyles.p1Grey,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                //* Изображение товара
                Container(
                  width: 100,
                  // constraints: const BoxConstraints(
                  //   minHeight: 100,
                  // ),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Image.asset(
                    img(model), //! model.img
                    scale: 3,
                  ),
                ),
              ],
            ),

            //* Информация о доставке
            if ((model is ProductItemModel) && deliveryInfo != null)
              Container(
                //margin: const EdgeInsets.only(top: 2),
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
                      child: RichText(
                        text: TextSpan(
                          text: 'Доставлен. ',
                          style: AppStyles.p1,
                          children: [
                            TextSpan(
                              style: AppStyles.p1Grey,
                              // TODO сделать открытие всплывашки
                              children: [
                                const TextSpan(
                                  text: 'Eсли нет, пишите ',
                                ),
                                TextSpan(
                                  text: 'сюда',
                                  style: AppStyles.p1Grey.copyWith(
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                const TextSpan(
                                  text: ', разберемся',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (model is! ProductItemModel)
              Container(
                margin: const EdgeInsets.only(top: 30),
                child: GreyButton(
                  text: txt(model),
                  icon: icon(model),
                  onPressed: () {
                    callback(model);
                  },
                ),
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

Widget icon(CatalogItemModel _model) {
  if (_model is WebinarItemModel) {
    return Container();
  } else if (_model is PartnersItemModel) {
    return Image.asset(
      'assets/copy.png',
      height: 16,
    );
  } else {
    return Image.asset(
      'assets/icons/preview.png',
      height: 16,
    );
  }
}

void callback(CatalogItemModel _model) {
  if (_model is WebinarItemModel) {
    showDialog<void>(
      context: Keys.mainNav.currentContext!,
      // TODO(Danil): массив id
      builder: (context) => VimeoPopup(
        videoId: _model.videoId.first,
      ),
    );
  } else if (_model is PartnersItemModel) {
    Clipboard.setData(ClipboardData(text: _model.poolPromoCode));
    showDefaultNotification(title: 'Скопировано!');
  } else {
    // TODO(Nikolay): Тут.
    showFlexibleBottomSheet<void>(
      context: Keys.mainNav.currentContext!,
      minHeight: 0,
      initHeight: 0.9,
      maxHeight: 0.95,
      anchors: [0, 0.6, 0.95],
      builder: (context, controller, d) {
        return FinalDiscountOptics(
          // TODO(Nikolay): Здесь.
          discountType: DiscountTypeClass.offline,
          controller: ScrollController(),
          model: _model as PromoItemModel,
          buttonText: 'Готово',
        );
      },
    );
  }
}

class GreyButton extends StatelessWidget {
  final String text;
  final Widget icon;
  final VoidCallback? onPressed;
  const GreyButton({
    required this.text,
    required this.icon,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
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
            icon,
          ],
        ),
      ),
    );
  }
}
