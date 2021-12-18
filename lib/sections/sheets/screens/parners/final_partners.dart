import 'package:bausch/models/catalog_item/partners_item_model.dart';
import 'package:bausch/sections/sheets/widgets/container_with_promocode.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/123/default_notification.dart';
import 'package:bausch/widgets/buttons/bottom_button.dart';
import 'package:bausch/widgets/catalog_item/big_catalog_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FinalPartners extends StatelessWidget {
  final ScrollController controller;
  final PartnersItemModel model;
  const FinalPartners({
    required this.controller,
    required this.model,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(5),
        topRight: Radius.circular(5),
      ),
      child: Scaffold(
        backgroundColor: AppTheme.sulu,
        body: CustomScrollView(
          controller: controller,
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: StaticData.sidePadding,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    CustomSliverAppbar.toClose(
                      Container(),
                      key,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 20,
                        bottom: 40,
                      ),
                      // TODO(Nikolay): Брать с сервера.
                      child: Text(
                        'Это ваш промокод на 45-дневную подписку на онлайн-кинотеатр More.TV',
                        style: AppStyles.h1,
                      ),
                    ),
                    // WhiteRoundedContainer(
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       Text(
                    //         model.poolPromoCode,
                    //         style: AppStyles.h2,
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    ContainerWithPromocode(
                      promocode: model.poolPromoCode,
                      onPressed: copyCode,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 12,
                        bottom: 40,
                      ),
                      // TODO(Nikolay): Брать с сервера.
                      child: Text(
                        'Промокод можно использовать в течение полугода. Он истечёт 28 февраля 2022 года. Промокод хранится в Профиле.',
                        style: AppStyles.p1,
                      ),
                    ),
                    BigCatalogItem(model: model),
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: BottomButtonWithRoundedCorners(
          text: 'Скопировать код и перейти на сайт',
          withInfo: false,
          onPressed: () {
            copyCode();
            // TODO(Nikolay): Переход на сайт.
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  void copyCode() {
    Clipboard.setData(ClipboardData(text: model.poolPromoCode));
    showDefaultNotification(title: 'Скопировано!');
  }
}
