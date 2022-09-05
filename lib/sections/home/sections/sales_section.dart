import 'package:bausch/models/sheets/base_catalog_sheet_model.dart';
import 'package:bausch/models/sheets/catalog_sheet_model.dart';
import 'package:bausch/sections/home/widgets/containers/sales_wide_container.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/text_button.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SalesWidget extends StatelessWidget {
  final List<BaseCatalogSheetModel> catalogList;
  final List<BaseCatalogSheetModel> actualList = [];
  SalesWidget({required this.catalogList, Key? key}) : super(key: key) {
    // TODO(info): обрабатываем скидки за баллы
    for (final element in catalogList) {
      if (element.type.contains('offline') || element.type.contains('online')) {
        actualList.add(element);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final height =
        MediaQuery.of(context).size.width / 2 - StaticData.sidePadding - 2;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: StaticData.sidePadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Скидки за баллы',
                style: AppStyles.h1,
              ),
              CustomTextButton(
                title: 'Все',
                titleStyle: AppStyles.h2,
                arrowSize: 14,
                onPressed: () =>
                    Navigator.of(Keys.mainContentNav.currentContext!).pushNamed(
                  '/sales',
                  arguments: actualList,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          height: height * 0.93,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: actualList.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (_, index) {
              return Padding(
                padding: EdgeInsets.only(
                  left: index == 0 ? StaticData.sidePadding : 0,
                  right: index == actualList.length - 1
                      ? StaticData.sidePadding
                      : 4,
                ),
                child: SaleWideContainer(
                  width: (MediaQuery.of(context).size.width / 2 -
                          StaticData.sidePadding -
                          2) *
                      1.7,
                  model: actualList[index] as CatalogSheetModel,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
