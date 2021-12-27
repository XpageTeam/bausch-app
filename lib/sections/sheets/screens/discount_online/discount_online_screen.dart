import 'package:bausch/models/catalog_item/promo_item_model.dart';
import 'package:bausch/sections/sheets/product_sheet/info_section.dart';
import 'package:bausch/sections/sheets/product_sheet/legal_info.dart';
import 'package:bausch/sections/sheets/product_sheet/select_shop.dart';
import 'package:bausch/sections/sheets/product_sheet/top_section.dart';
import 'package:bausch/sections/sheets/screens/discount_optics/discount_type.dart';
import 'package:bausch/sections/sheets/sheet_screen.dart';
import 'package:bausch/sections/sheets/widgets/custom_sheet_scaffold.dart';
import 'package:bausch/sections/sheets/widgets/how_to_use_promocode.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/sections/sheets/widgets/warning_widget.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/floatingactionbutton.dart';
import 'package:bausch/widgets/discount_info.dart';
import 'package:flutter/material.dart';

//catalog_discount_online_store
@Deprecated('Этот экран не нужен. Вместо него - DiscountOpticScreen')
class DiscountOnlineScreen extends StatelessWidget
    implements ItemSheetScreenArguments {
  final ScrollController controller;
  @override
  final PromoItemModel model;

  @Deprecated('Этот экран не нужен. Вместо него - DiscountOpticScreen')
  const DiscountOnlineScreen({
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
        icon: Container(),
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
                  secondText: '',
                ),
                const SizedBox(
                  height: 12,
                ),
              ],
            ),
          ),
        ),
        const SliverPadding(
          padding: EdgeInsets.fromLTRB(
            StaticData.sidePadding,
            12,
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
          padding: const EdgeInsets.fromLTRB(
            StaticData.sidePadding,
            0,
            StaticData.sidePadding,
            20,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                Text(
                  'Выбрать интернет-магазин',
                  style: AppStyles.h2,
                ),
              ],
            ),
          ),
        ),
        // SliverPadding(
        //   padding: const EdgeInsets.symmetric(
        //     horizontal: StaticData.sidePadding,
        //   ),
        //   sliver: SelectShopSection(
        //     selectedOptic: ,
        //     discountOptics: const [],
        //     onChanged: (discountOptic) {},
        //     discountType: DiscountType.onlineShop,
        //   ),
        // ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: StaticData.sidePadding,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                Warning.warning(),
                const Padding(
                  padding: EdgeInsets.only(top: 40, bottom: 160),
                  //TODO(Nikita): это приходит с бэка или в приложении
                  child: HowToUsePromocode(),
                ),
              ],
            ),
          ),
        ),
      ],
      bottomNavBar: CustomFloatingActionButton(
        text: 'Получить скидку',
        onPressed: () {
          Navigator.of(context).pushNamed(
            '/verification_discount_online',
            arguments: ItemSheetScreenArguments(model: model),
          );
        },
      ),
    );
  }
}
