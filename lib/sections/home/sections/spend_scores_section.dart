import 'package:bausch/models/sheets/base_catalog_sheet_model.dart';
import 'package:bausch/models/sheets/catalog_sheet_model.dart';
import 'package:bausch/sections/home/widgets/containers/small_container.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SpendScores extends StatelessWidget {
  final List<BaseCatalogSheetModel> catalogList;
  List<BaseCatalogSheetModel> actualList = [];
  SpendScores({
    required this.catalogList,
    Key? key,
  }) : super(key: key) {
    for (final element in catalogList) {
      if (element.type != 'offline' && element.type != 'onlineShop') {
        actualList.add(element);
      }
    }
  }

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
            children: actualList.map((catItem) {
              // if (catItem.type == 'offline') {
              //   return WideContainerWithItems(
              //     model: catItem as CatalogSheetWithLogosModel,
              //   );
              // } else if (catItem.type == 'online_consultation') {
              //   return WideContainerWithoutItems(
              //     model: catItem as CatalogSheetWithoutLogosModel,
              //   );
              // } else {
              return SmallContainer(
                model: catItem as CatalogSheetModel,
              );
              // }
            }).toList(),
          ),
        ),
      ],
    );
  }
}
