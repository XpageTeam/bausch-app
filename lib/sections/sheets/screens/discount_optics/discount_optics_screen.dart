import 'package:bausch/models/catalog_item/promo_item_model.dart';
import 'package:bausch/sections/sheets/widgets/custom_sheet_scaffold.dart';
import 'package:bausch/sections/sheets/product_sheet/info_section.dart';
import 'package:bausch/sections/sheets/product_sheet/legal_info.dart';
import 'package:bausch/sections/sheets/product_sheet/select_optics.dart';
import 'package:bausch/sections/sheets/product_sheet/top_section.dart';
import 'package:bausch/sections/sheets/sheet_screen.dart';
import 'package:bausch/sections/sheets/widgets/how_to_use_promocode.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/sections/sheets/widgets/warning_widget.dart';
import 'package:bausch/sections/shops/shops_screen.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/floatingactionbutton.dart';
import 'package:bausch/widgets/buttons/white_button.dart';
import 'package:bausch/widgets/discount_info.dart';
import 'package:flutter/material.dart';

//catalog_discount_optics
class DiscountOpticsScreen extends StatelessWidget
    implements SheetScreenArguments {
  final ScrollController controller;

  @override
  final PromoItemModel model;

  const DiscountOpticsScreen({
    required this.controller,
    required this.model,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomSheetScaffold(
      controller: controller,
      appBar: CustomSliverAppbar(
        padding: const EdgeInsets.all(18),
        icon: Container(
          height: 1,
        ),
        iconColor: AppTheme.mystic,
      ),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.only(
            top: 12,
            left: 12,
            right: 12,
            bottom: 4,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                TopSection.product(
                  model,
                  const DiscountInfo(text: 'Скидка 500 ₽ '),
                  key,
                ),
                const SizedBox(
                  height: 4,
                ),
                InfoSection(
                  text: model.previewText,
                  secondText: model.detailText,
                ),
                const SizedBox(
                  height: 12,
                ),
                // const LegalInfo(
                //   texts: [],
                // ),
              ],
            ),
          ),
        ),
        const SliverPadding(
          padding: EdgeInsets.fromLTRB(
            StaticData.sidePadding,
            0,
            StaticData.sidePadding,
            40,
          ),
          sliver: LegalInfo(
            texts: [
              'Перед заказом промокода на скидку необходимо проверить наличие продукта (на сайте и / или по контактному номеру телефона оптики).',
              'Срок действия промокода и количество промокодов ограничены. ',
            ],
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.only(
            left: StaticData.sidePadding,
            right: StaticData.sidePadding,
            //top: 20,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                Text(
                  'Выбрать сеть оптик',
                  style: AppStyles.h1,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 12,
                    bottom: 20,
                  ),
                  child: Text(
                    'Скидкой можно воспользоваться в любой из оптик сети.',
                    style: AppStyles.p1,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: StaticData.sidePadding),
          //TODO(Nikita): customCheckBox
          sliver: SelectOpticsSection(),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: StaticData.sidePadding,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 30,
                    bottom: 4,
                  ),
                  child: WhiteButton(
                    text: 'Адреса оптик',
                    padding: const EdgeInsets.fromLTRB(16, 26, 16, 28),
                    icon: Padding(
                      padding: const EdgeInsets.only(
                        right: 12,
                      ),
                      child: Image.asset(
                        'assets/icons/map-marker.png',
                        height: 16,
                      ),
                    ),
                    onPressed: () {
                      Keys.mainNav.currentState!
                          .push<void>(MaterialPageRoute(builder: (context) {
                        return ShopsScreen();
                      }));
                    },
                  ),
                ),
                Warning.warning(),
                const Padding(
                  padding: EdgeInsets.only(top: 40, bottom: 20),
                  child: HowToUsePromocode(
                    text:
                        'Покажите промокод в оптике при покупке выбранного продукта. Срок действия промокода и количество промокодов ограничены. ',
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
      bottomButton: CustomFloatingActionButton(
        text: 'Получить скидку',
        onPressed: () {
          Keys.bottomSheetItemsNav.currentState!.pushNamed(
            '/verification_discount_optics',
            arguments: SheetScreenArguments(model: model),
          );
        },
      ),
    );
  }
}
