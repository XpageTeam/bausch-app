import 'package:bausch/models/catalog_item/catalog_item_model.dart';
import 'package:bausch/sections/sheets/product_sheet/info_section.dart';
import 'package:bausch/sections/sheets/product_sheet/legal_info.dart';
import 'package:bausch/sections/sheets/product_sheet/top_section.dart';
import 'package:bausch/sections/sheets/sheet_screen.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/widgets/buttons/normal_icon_button.dart';
import 'package:flutter/material.dart';

//catalog_free_packaging
class GoodsScreen extends StatelessWidget implements SheetScreenArguments {
  final ScrollController controller;

  @override
  final CatalogItemModel model;

  const GoodsScreen({
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
                    TopSection.packaging(
                      model: model,
                      key: key,
                      rightKey: Keys.mainNav,
                      leftIcon: NormalIconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        }, //Navigator.of(context).pop,
                        backgroundColor: AppTheme.mystic,
                        icon: const Icon(
                          Icons.chevron_left_rounded,
                          size: 20,
                          color: AppTheme.mineShaft,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    InfoSection(
                      text: model.previewText,
                      //secondText: model.detailText,
                    ),
                    // const SizedBox(
                    //   height: 12,
                    // ),

                    // const SizedBox(
                    //   height: 160,
                    // ),
                  ],
                ),
              ),
            ),
            const SliverPadding(
              padding: EdgeInsets.fromLTRB(
                StaticData.sidePadding,
                12,
                StaticData.sidePadding,
                30,
              ),
              sliver: LegalInfo(
                texts: [
                  'Надеть первую бесплатную пару линз вам поможет специалист. Подарочные линзы не выдаются в блистерной упаковке.',
                  'Бесплатная пара выдается оптикой в случае наличия подходящих диоптрий.',
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
