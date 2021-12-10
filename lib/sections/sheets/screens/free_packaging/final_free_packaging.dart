import 'package:bausch/models/catalog_item/catalog_item_model.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/bottom_button.dart';
import 'package:bausch/widgets/catalog_item/big_catalog_item.dart';
import 'package:bausch/widgets/text/bulleted_list.dart';
import 'package:flutter/material.dart';

class FinalFreePackaging extends StatelessWidget {
  final ScrollController controller;
  final CatalogItemModel model;
  const FinalFreePackaging({
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
        resizeToAvoidBottomInset: false,
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
                    CustomSliverAppbar.toPop(
                      icon: Container(),
                      key: key,
                      backgroundColor: Colors.white,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        'Заказ успешно оформлен',
                        style: AppStyles.h2,
                      ),
                    ),
                    // DefaultTextInput(
                    //     labelText: 'labelText',
                    //     controller: TextEditingController()),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 12,
                        bottom: 40,
                      ),
                      child: Text(
                        'За статусом заказа можно будет следить в Профиле.',
                        style: AppStyles.p1,
                      ),
                    ),
                    BigCatalogItem(model: model),
                    Padding(
                      padding: const EdgeInsets.only(top: 12, bottom: 120),
                      child: Column(
                        children: const [
                          // TODO(Nikolay): Проверить.
                          BulletedList(
                            list: [
                              'После того, как данные заказа будут переданы логистической компании, мы позвоним для подтверждения адреса доставки и данных получателя по указанному в профиле номеру телефона. Обычно это происходит в течение 2-3 недель. Если нам не удастся дозвониться, мы будем вынуждены отменить заказ.',
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: const BottomButtonWithRoundedCorners(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
