import 'package:bausch/models/sheets/base_catalog_sheet_model.dart';
import 'package:bausch/models/sheets/catalog_sheet_model.dart';
import 'package:bausch/models/sheets/catalog_sheet_with_logos.dart';
import 'package:bausch/models/sheets/catalog_sheet_without_logos_model.dart';
import 'package:bausch/sections/home/widgets/containers/small_container.dart';
import 'package:bausch/sections/home/widgets/containers/wide_container_with_items.dart';
import 'package:bausch/sections/home/widgets/containers/wide_container_without_items.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class SpendScores extends StatelessWidget {
  final List<BaseCatalogSheetModel> catalogList;
  const SpendScores({
    required this.catalogList,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Потратить баллы',
          style: AppStyles.h1,
        ),
        const SizedBox(
          height: 20,
        ),
        Flexible(
          child: Wrap(
            spacing: 4,
            runSpacing: 4,
            children: catalogList.map((catItem) {
              if (catItem.type == 'offline') {
                return WideContainerWithItems(
                  model: catItem as CatalogSheetWithLogosModel,
                );
              } else if (catItem.type == 'online_consultation') {
                return WideContainerWithoutItems(
                  model: catItem as CatalogSheetWithoutLogosModel,
                );
              } else {
                return SmallContainer(
                  model: catItem as CatalogSheetModel,
                );
              }
            }).toList(),
          ),
        ),
      ],
    );
  }
}
