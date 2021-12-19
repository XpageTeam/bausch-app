import 'package:bausch/models/catalog_item/catalog_item_model.dart';
import 'package:bausch/sections/sheets/sheet_screen.dart';
import 'package:bausch/sections/sheets/widgets/custom_sheet_scaffold.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/floatingactionbutton.dart';
import 'package:bausch/widgets/catalog_item/big_catalog_item.dart';
import 'package:flutter/material.dart';

class ConsultationVerification extends StatelessWidget {
  final ScrollController controller;
  final CatalogItemModel model;
  const ConsultationVerification({
    required this.controller,
    required this.model,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomSheetScaffold(
      backgroundColor: AppTheme.mystic,
      controller: controller,
      appBar: const CustomSliverAppbar(
        padding: EdgeInsets.all(18),
      ),
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
                    const SizedBox(
                      height: 78,
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
                          'После подтверждения мы спишем баллы, и вы получите промокод',
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
                      'После покупки у вас останется 100 баллов',
                      style: AppStyles.p1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
      bottomNavBar: CustomFloatingActionButton(
        text: 'Потратить ${model.price} б',
        onPressed: () {
          Navigator.of(context).pushNamed(
            '/final_consultation',
            arguments: ItemSheetScreenArguments(model: model),
          );
        },
      ),
    );
  }
}
