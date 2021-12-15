import 'package:bausch/models/catalog_item/catalog_item_model.dart';
import 'package:bausch/sections/sheets/sheet_screen.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/floatingactionbutton.dart';
import 'package:bausch/widgets/buttons/normal_icon_button.dart';
import 'package:bausch/widgets/catalog_item/big_catalog_item.dart';
import 'package:flutter/material.dart';

class WebinarVerification extends StatelessWidget {
  final ScrollController controller;
  final CatalogItemModel model;
  const WebinarVerification({
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
                            onPressed: () {
                              Navigator.of(context).pop();
                            }, //Navigator.of(context).pop,
                            icon: const Icon(
                              Icons.chevron_left_rounded,
                              size: 20,
                              color: AppTheme.mineShaft,
                            ),
                          ),
                          key: key,
                          backgroundColor: Colors.white,
                          rightKey: Keys.mainNav,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Подтвердите заказ',
                          style: AppStyles.h1,
                        ),
                        Column(
                          children: [
                            const SizedBox(
                              height: 12,
                            ),
                            Text(
                              'После подтверждения мы спишем баллы, и вы получите доступ к записи',
                              style: AppStyles.p1,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 40,
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
          icon: Container(),
          onPressed: () {
            Keys.bottomSheetItemsNav.currentState!.pushNamed(
              '/final_webinar',
              arguments: SheetScreenArguments(model: model),
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
