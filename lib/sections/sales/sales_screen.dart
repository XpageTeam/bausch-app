import 'package:bausch/models/sheets/base_catalog_sheet_model.dart';
import 'package:bausch/models/sheets/catalog_sheet_model.dart';
import 'package:bausch/sections/home/widgets/containers/sales_wide_container.dart';
import 'package:bausch/sections/home/widgets/containers/small_container.dart';
import 'package:bausch/sections/home/widgets/containers/white_container_with_rounded_corners.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:flutter/material.dart';

class SalesScreen extends StatefulWidget {
  final List<BaseCatalogSheetModel> salesList;
  const SalesScreen({required this.salesList, Key? key}) : super(key: key);

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  List<BaseCatalogSheetModel> activeList = [];
  int activeFilterId = 0;
  int containerId = -1;

  @override
  void initState() {
    activeList = [...widget.salesList];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar(
        title: 'Скидки за баллы',
        backgroundColor: AppTheme.mystic,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: StaticData.sidePadding),
        child:
            CustomScrollView(physics: const BouncingScrollPhysics(), slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 30,
                bottom: 20,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        containerId = -1;
                        activeFilterId = 0;
                        activeList = [...widget.salesList];
                      });
                    },
                    child: WhiteContainerWithRoundedCorners(
                      color:
                          activeFilterId == 0 ? Colors.white : AppTheme.mystic,
                      child: const Text(
                        'Все',
                        style: AppStyles.h2,
                      ),
                      padding: const EdgeInsets.all(10),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        containerId = -1;
                        activeFilterId = 1;
                        activeList = [
                          ...widget.salesList.where(
                            (element) => element.type.contains('offline'),
                          ),
                        ];
                      });
                    },
                    child: WhiteContainerWithRoundedCorners(
                      color:
                          activeFilterId == 1 ? Colors.white : AppTheme.mystic,
                      child: const Text(
                        'В оффлайн',
                        style: AppStyles.h2,
                      ),
                      padding: const EdgeInsets.all(10),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        containerId = -1;
                        activeFilterId = 2;
                        activeList = [
                          ...widget.salesList.where(
                            (element) => element.type.contains('online'),
                          ),
                        ];
                      });
                    },
                    child: WhiteContainerWithRoundedCorners(
                      color:
                          activeFilterId == 2 ? Colors.white : AppTheme.mystic,
                      child: const Text(
                        'В онлайн',
                        style: AppStyles.h2,
                      ),
                      padding: const EdgeInsets.all(10),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Wrap(
              spacing: 4,
              runSpacing: 4,
              children: activeList.map((catItem) {
                containerId++;
                if (containerId == 0) {
                  return SaleWideContainer(
                    height: (MediaQuery.of(context).size.width / 2 -
                            StaticData.sidePadding -
                            2) *
                        0.9,
                    model: catItem as CatalogSheetModel,
                  );
                }
                return SmallContainer(
                  model: catItem as CatalogSheetModel,
                );
              }).toList(),
            ),
          ),
        ]),
      ),
    );
  }
}
