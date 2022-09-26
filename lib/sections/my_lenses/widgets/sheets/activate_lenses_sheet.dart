import 'package:bausch/models/my_lenses/lens_product_list_model.dart';
import 'package:bausch/models/my_lenses/lenses_pair_model.dart';
import 'package:bausch/models/my_lenses/recommended_products_list_modul.dart';
import 'package:bausch/packages/bottom_sheet/src/widgets/flexible_draggable_scrollable_sheet.dart';
import 'package:bausch/sections/home/widgets/containers/white_container_with_rounded_corners.dart';
import 'package:bausch/sections/home/widgets/simple_slider/simple_slider.dart';
import 'package:bausch/sections/my_lenses/widgets/lens_description.dart';
import 'package:bausch/sections/my_lenses/widgets/recommended_product.dart';
import 'package:bausch/sections/sheets/widgets/custom_sheet_scaffold.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:flutter/material.dart';

class ActivateLensesSheet extends StatelessWidget {
  final VoidCallback onActivate;
  final LensesPairModel lensesPairModel;
  final LensProductModel lensProductModel;
  final List<RecommendedProductModel> recommendedProducts;
  final FlexibleDraggableScrollableSheetScrollController controller;
  const ActivateLensesSheet({
    required this.onActivate,
    required this.controller,
    required this.lensesPairModel,
    required this.lensProductModel,
    required this.recommendedProducts,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomSheetScaffold(
      controller: controller,
      resizeToAvoidBottomInset: false,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(StaticData.sidePadding),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              WhiteContainerWithRoundedCorners(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: StaticData.sidePadding,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  lensProductModel.name,
                                  style: AppStyles.h2,
                                ),
                                Text(
                                  lensProductModel.lifeTime > 1
                                      ? 'Плановой замены \nДо${lensProductModel.lifeTime} суток'
                                      : 'Однодневные',
                                  style: AppStyles.p1,
                                ),
                                Text(
                                  'Пар: ${lensProductModel.count}',
                                  style: AppStyles.p1,
                                ),
                              ],
                            ),
                          ),
                          Image.network(
                            lensProductModel.image,
                            height: 100,
                            width: 100,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      BlueButtonWithText(
                        text: 'Сделать активными',
                        onPressed: () {
                          Navigator.of(context).pop();
                          onActivate();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 4),
              WhiteContainerWithRoundedCorners(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: StaticData.sidePadding,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: LensDescription(
                        title: 'L',
                        pairModel: lensesPairModel.left,
                      ),
                    ),
                    Expanded(
                      child: LensDescription(
                        title: 'R',
                        pairModel: lensesPairModel.right,
                      ),
                    ),
                  ],
                ),
              ),
              if (recommendedProducts.isNotEmpty)
                const Padding(
                  padding: EdgeInsets.only(
                    top: 30,
                    bottom: 16,
                    left: StaticData.sidePadding,
                  ),
                  child: Text(
                    'Рекомендуемые продукты',
                    style: AppStyles.h1,
                  ),
                ),
              if (recommendedProducts.isNotEmpty)
                SimpleSlider<RecommendedProductModel>(
                  items: recommendedProducts,
                  builder: (context, product) {
                    return RecommendedProduct(product: product);
                  },
                ),
              // TODO(ask): на бэке пока нет истории ношения
              // if (lensProductModel.lifeTime > 1)
              //   const Text(
              //     'История ношения',
              //     style: AppStyles.h1,
              //   ),
              //        if(lensProductModel.lifeTime > 1)
              //       Padding(
              //         padding: const EdgeInsets.only(top:20),
              //         child: Row(
              // children: [
              //   Expanded(
              //     child: StreamedStateBuilder<List<LensesWornHistoryModel>>(
              //         streamedState: myLensesWM.wornHistoryList,
              //         builder: (_, historyList) => historyList.isNotEmpty
              //             ? WhiteContainerWithRoundedCorners(
              //                 padding: const EdgeInsets.symmetric(
              //                   vertical: 30,
              //                   horizontal: StaticData.sidePadding,
              //                 ),
              //                 child: Column(
              //                   crossAxisAlignment: CrossAxisAlignment.start,
              //                   children: [
              //                     Row(
              //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                       children: const [
              //                         Expanded(
              //                           child: Text(
              //                             'Надеты',
              //                             style: AppStyles.p1Grey,
              //                             textAlign: TextAlign.center,
              //                           ),
              //                         ),
              //                         Expanded(
              //                           child: Text(
              //                             'Заменены',
              //                             style: AppStyles.p1Grey,
              //                             textAlign: TextAlign.center,
              //                           ),
              //                         ),
              //                       ],
              //                     ),
              //                     const SizedBox(height: 20),
              //                     ListView.builder(
              //                       shrinkWrap: true,
              //                       itemCount: historyList.length,
              //                       itemBuilder: (_, index) => Padding(
              //                         padding: const EdgeInsets.only(bottom: 20),
              //                         child: Row(
              //                           children: [
              //                             if (historyList[index].eye == 'LR')
              //                               Image.asset(
              //                                 'assets/icons/halfed_circle.png',
              //                                 height: 16,
              //                                 width: 16,
              //                               )
              //                             else
              //                               Container(
              //                                 height: 16,
              //                                 width: 16,
              //                                 decoration: BoxDecoration(
              //                                   shape: BoxShape.circle,
              //                                   color: historyList[index].eye == 'L'
              //                                       ? AppTheme.turquoiseBlue
              //                                       : AppTheme.sulu,
              //                                 ),
              //                                 child: Center(
              //                                   child: Text(
              //                                     historyList[index].eye,
              //                                     style: AppStyles.n1,
              //                                   ),
              //                                 ),
              //                               ),
              //                             const SizedBox(width: 8),
              //                             Center(
              //                               child: Text(
              //                                 HelpFunctions.formatDateRu(
              //                                   date: historyList[index].dateStart,
              //                                 ),
              //                                 style: AppStyles.p1,
              //                               ),
              //                             ),
              //                             Padding(
              //                               padding: const EdgeInsets.symmetric(
              //                                 horizontal: 6,
              //                               ),
              //                               child: Image.asset(
              //                                 'assets/line_dots.png',
              //                                 scale: 4.1,
              //                               ),
              //                             ),
              //                             Center(
              //                               child: historyList[index].dateEnd != null
              //                                   ? Text(
              //                                       HelpFunctions.formatDateRu(
              //                                         date:
              //                                             historyList[index].dateEnd!,
              //                                       ),
              //                                       style: AppStyles.p1,
              //                                     )
              //                                   : const SizedBox.shrink(),
              //                             ),
              //                           ],
              //                         ),
              //                       ),
              //                     ),
              //                     const GreyButton(
              //                       text: 'Ранее',
              //                       padding: EdgeInsets.symmetric(
              //                         vertical: 10,
              //                         horizontal: StaticData.sidePadding,
              //                       ),
              //                     ),
              //                   ],
              //                 ),
              //               )
              //             : const WhiteContainerWithRoundedCorners(
              //                 padding: EdgeInsets.symmetric(
              //                   vertical: 30,
              //                   horizontal: StaticData.sidePadding,
              //                 ),
              //                 child: Text(
              //                   'Покажем когда вы надели и сняли линзы',
              //                   style: AppStyles.p1Grey,
              //                   textAlign: TextAlign.center,
              //                 ),
              //               ),
              //     ),
              //   ],
              // ),
              // ),
            ]),
          ),
        ),
      ],
    );
  }
}
