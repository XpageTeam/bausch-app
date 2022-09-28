import 'package:bausch/help/help_functions.dart';
import 'package:bausch/models/my_lenses/lens_product_list_model.dart';
import 'package:bausch/packages/bottom_sheet/src/widgets/flexible_draggable_scrollable_sheet.dart';
import 'package:bausch/sections/home/widgets/containers/white_container_with_rounded_corners.dart';
import 'package:bausch/sections/sheets/widgets/custom_sheet_scaffold.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class ChooseProductSheet extends StatelessWidget {
  final FlexibleDraggableScrollableSheetScrollController controller;
  final LensProductListModel lensProductListModel;
  final void Function(LensProductModel product) acceptProduct;
  const ChooseProductSheet({
    required this.controller,
    required this.lensProductListModel,
    required this.acceptProduct,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomSheetScaffold(
      controller: controller,
      resizeToAvoidBottomInset: false,
      slivers: [
        const SliverPadding(
          padding: EdgeInsets.symmetric(
            vertical: 40,
            horizontal: StaticData.sidePadding,
          ),
          sliver: SliverToBoxAdapter(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Выберите продукт',
                style: AppStyles.h1,
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: StaticData.sidePadding,
          ),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: GestureDetector(
                    onTap: () {
                      acceptProduct(lensProductListModel.products[index]);
                      Navigator.of(context).pop();
                    },
                    child: WhiteContainerWithRoundedCorners(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: StaticData.sidePadding,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  lensProductListModel.products[index].name,
                                  style: AppStyles.h2,
                                ),
                                Text(
                                  lensProductListModel
                                              .products[index].lifeTime >
                                          1
                                      ? 'Плановой замены \nДо ${lensProductListModel.products[index].lifeTime} суток'
                                      : 'Однодневные',
                                  style: AppStyles.p1,
                                ),
                                Text(
                                  HelpFunctions.pairs(
                                    int.parse(lensProductListModel
                                        .products[index].count),
                                  ),
                                  style: AppStyles.p1,
                                ),
                              ],
                            ),
                          ),
                          Image.network(
                            lensProductListModel.products[index].image,
                            height: 100,
                            width: 100,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              childCount: lensProductListModel.products.length,
            ),
          ),
        ),
      ],
    );
  }
}
