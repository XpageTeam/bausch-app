import 'package:bausch/models/catalog_item/catalog_item_model.dart';
import 'package:bausch/sections/sheets/widgets/custom_sheet_scaffold.dart';
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
  final VoidCallback? onPressed;
  const FinalFreePackaging({
    required this.controller,
    required this.model,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomSheetScaffold(
      //resizeToAvoidBottomInset: false,
      showScrollbar: true,
      backgroundColor: AppTheme.sulu,
      controller: controller,
      appBar: CustomSliverAppbar(
        padding: const EdgeInsets.all(18),
        icon: Container(
          height: 1,
        ),
        //iconColor: AppTheme.mystic,
      ),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: StaticData.sidePadding,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                const Padding(
                  padding: EdgeInsets.only(top: 78),
                  child: Text(
                    'Заказ успешно оформлен',
                    style: AppStyles.h1,
                  ),
                ),
                // DefaultTextInput(
                //     labelText: 'labelText',
                //     controller: TextEditingController()),
                const Padding(
                  padding: EdgeInsets.only(
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
                  padding: const EdgeInsets.only(top: 12, bottom: 30),
                  child: Column(
                    children: const [
                      BulletedRow(
                        text:
                            'После того, как данные заказа будут переданы логистической компании, мы позвоним для подтверждения адреса доставки '
                            'и данных получателя по указанному в профиле номеру телефона. Обычно это происходит в течение 2-3 недель. '
                            'Если нам не удастся дозвониться, мы будем вынуждены отменить заказ.',
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      BulletedRow(
                        text:
                            'Когда груз будет скомплектован, на указанные в профиле номер телефона и e-mail придет трек-номер. ',
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      BulletedRow(
                        text:
                            'Обращаем внимание, что в общей сложности обработка и доставка заказа осуществляются в течение 60 рабочих дней.',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
      bottomNavBar: const BottomButtonWithRoundedCorners(),
    );
  }
}
