import 'package:bausch/models/catalog_item_model.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/bottom_info_block.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/catalog_item/big_catalog_item.dart';
import 'package:flutter/material.dart';

class FinalWebinar extends StatelessWidget {
  final ScrollController controller;
  final CatalogItemModel model;
  const FinalWebinar({
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
                    const CustomSliverAppbar(),
                    const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text(
                        'Ваш доступ к записи вебинара',
                        style: AppStyles.h2,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        top: 12,
                        bottom: 40,
                      ),
                      child: Text(
                        'Доступ видео у вас будет всегда, путь к нему будет в Профиле и в разделе «Записи вебинаров»',
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
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: StaticData.sidePadding,
              ),
              child: BlueButtonWithText(
                text: 'На главную',
                onPressed: () {
                  Utils.bottomSheetNav.currentState!
                      .pushNamedAndRemoveUntil('/', ModalRoute.withName('/'));
                },
              ),
            ),
            const InfoBlock(),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
