import 'package:bausch/models/offer/offer.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

/*
homeScreen - главный экран, (index) 
notificationsScreen - Экран с уведомлениями (notifications)
offline - раздел Скидка 500 рублей в оптике
promoCodeImmediately - Предложения от партнеров (promo_code_immediately)
freeProduct - Бесплатная упаковка (free_product)
onlineShop - Скидка 500 рублей в интернет-магазине
promoCodeVideo - Записи вебинаров (promo_code_video)
onlineConsultation - Онлайн-консультация (online_consultation)
good - баннер у товара 
*/

enum OfferType {
  homeScreen,
  notificationsScreen,
  offline,
  promoCodeImmediately,
  freeProduct,
  onlineShop,
  promoCodeVideo,
  onlineConsultation,
  good,
}

class OfferWidget extends StatefulWidget {
  final Offer offer;

  final VoidCallback? onClose;
  final VoidCallback? onPressed;

  const OfferWidget({
    required this.offer,
    this.onClose,
    this.onPressed,
    Key? key,
  }) : super(
          key: key,
        );

  @override
  State<StatefulWidget> createState() => _OfferWidgetState();
}

class _OfferWidgetState extends State<OfferWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        GestureDetector(
          onTap: widget.onPressed,
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.sulu,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 16,
                right: StaticData.sidePadding,
                left: StaticData.sidePadding,
                bottom: 30,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          widget.offer.title,
                          style: AppStyles.h1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (widget.offer.description != null) ...[
                        Flexible(
                          child: Text(
                            widget.offer.description!,
                            style: AppStyles.p1,
                          ),
                        ),
                      ] else ...[
                        const SizedBox(),
                      ],
                      InkWell(
                        onTap: widget.onPressed,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              'assets/banner-icon.png',
                              height: 60,
                            ),
                            const Positioned(
                              child: Icon(Icons.arrow_forward_sharp),
                              right: 10,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        if (widget.offer.isClosable)
          IconButton(
            onPressed: widget.onClose,
            icon: const Icon(Icons.close),
            splashRadius: 5,
          ),
      ],
    );
  }
}
