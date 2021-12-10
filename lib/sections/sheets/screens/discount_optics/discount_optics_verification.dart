import 'package:bausch/models/catalog_item/promo_item_model.dart';
import 'package:bausch/sections/sheets/sheet_screen.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/floatingactionbutton.dart';
import 'package:bausch/widgets/buttons/normal_icon_button.dart';
import 'package:bausch/widgets/catalog_item/big_catalog_item.dart';
import 'package:bausch/widgets/discount_info.dart';
import 'package:flutter/material.dart';

class DiscountOpticsVerification extends StatelessWidget {
  final ScrollController controller;
  final PromoItemModel model;
  const DiscountOpticsVerification({
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
        backgroundColor: AppTheme.mystic,
        body: CustomScrollView(
          controller: controller,
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: StaticData.sidePadding,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomSliverAppbar.toPop(
                          icon: NormalIconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios_new_sharp,
                              size: 20,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          key: key,
                          backgroundColor: Colors.white,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Подтвердите заказ',
                          style: AppStyles.h2,
                        ),
                        Column(
                          children: [
                            const SizedBox(
                              height: 12,
                            ),
                            Text(
                              'После подтверждения мы спишем баллы, и вы получите промокод',
                              style: AppStyles.p1,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const DiscountInfo(text: 'Скидка 500 ₽'),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              'в оптике ЛинзСервис',
                              style: AppStyles.h2,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        BigCatalogItem(
                          model: model,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Text(
                          'После заказа у вас останется 100 баллов',
                          style: AppStyles.p1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: CustomFloatingActionButton(
          text: 'Потратить ${model.price} б',
          onPressed: () {
            Keys.bottomSheetItemsNav.currentState!.pushNamed(
              '/final_discount_optics',
              arguments: SheetScreenArguments(model: model),
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
