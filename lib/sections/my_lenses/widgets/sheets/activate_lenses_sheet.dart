import 'package:bausch/help/help_functions.dart';
import 'package:bausch/models/my_lenses/lens_product_list_model.dart';
import 'package:bausch/models/my_lenses/lenses_pair_model.dart';
import 'package:bausch/models/my_lenses/lenses_worn_history_list_model.dart';
import 'package:bausch/models/my_lenses/recommended_products_list_modul.dart';
import 'package:bausch/packages/bottom_sheet/src/widgets/flexible_draggable_scrollable_sheet.dart';
import 'package:bausch/sections/home/widgets/containers/white_container_with_rounded_corners.dart';
import 'package:bausch/sections/home/widgets/simple_slider/simple_slider.dart';
import 'package:bausch/sections/my_lenses/my_lenses_wm.dart';
import 'package:bausch/sections/my_lenses/widgets/lens_description.dart';
import 'package:bausch/sections/my_lenses/widgets/lenses_history.dart';
import 'package:bausch/sections/my_lenses/widgets/recommended_product.dart';
import 'package:bausch/sections/sheets/widgets/custom_sheet_scaffold.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/loader/animated_loader.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class ActivateLensesSheet extends StatefulWidget {
  final MyLensesWM myLensesWM;
  final LensesPairModel lensesPairModel;
  final LensProductModel lensProductModel;
  final List<RecommendedProductModel> recommendedProducts;
  final FlexibleDraggableScrollableSheetScrollController controller;

  const ActivateLensesSheet({
    required this.controller,
    required this.lensesPairModel,
    required this.lensProductModel,
    required this.recommendedProducts,
    required this.myLensesWM,
    Key? key,
  }) : super(key: key);

  @override
  State<ActivateLensesSheet> createState() => _ActivateLensesSheetState();
}

class _ActivateLensesSheetState extends State<ActivateLensesSheet> {
  bool isUpdating = false;
  @override
  Widget build(BuildContext context) {
    return CustomSheetScaffold(
      controller: widget.controller,
      resizeToAvoidBottomInset: false,
      slivers: [
        if (isUpdating)
          const SliverPadding(
            padding: EdgeInsets.only(top: 100),
            sliver: SliverToBoxAdapter(
              child: Center(
                child: AnimatedLoader(),
              ),
            ),
          )
        else
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
                                    widget.lensProductModel.name,
                                    style: AppStyles.h2,
                                  ),
                                  Text(
                                    widget.lensProductModel.lifeTime > 1
                                        ? 'Плановой замены \nДо${widget.lensProductModel.lifeTime} суток'
                                        : 'Однодневные',
                                    style: AppStyles.p1,
                                  ),
                                  Text(
                                    HelpFunctions.pairs(
                                      int.parse(
                                        widget.lensProductModel.count,
                                      ),
                                    ),
                                    style: AppStyles.p1,
                                  ),
                                ],
                              ),
                            ),
                            Image.network(
                              widget.lensProductModel.image,
                              height: 100,
                              width: 100,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        BlueButtonWithText(
                          text: 'Сделать активными',
                          onPressed: () async {
                            setState(() {
                              isUpdating = true;
                            });
                            await widget.myLensesWM.activateOldLenses(
                              pairId: widget.lensesPairModel.id!,
                            );
                            // TODO(pavlov): посмотреть что будет
                            setState(() {
                              isUpdating = false;
                              Navigator.of(context).pop();
                            });
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
                          pairModel: widget.lensesPairModel.left,
                        ),
                      ),
                      Expanded(
                        child: LensDescription(
                          title: 'R',
                          pairModel: widget.lensesPairModel.right,
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.recommendedProducts.isNotEmpty)
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
                if (widget.recommendedProducts.isNotEmpty)
                  SimpleSlider<RecommendedProductModel>(
                    items: widget.recommendedProducts,
                    builder: (context, product) {
                      return RecommendedProduct(product: product);
                    },
                  ),
                if (widget.lensProductModel.lifeTime > 1)
                  StreamedStateBuilder<List<LensesWornHistoryModel>>(
                    streamedState: widget.myLensesWM.oldWornHistoryList,
                    builder: (_, oldWornHistoryList) => LensesHistory(
                      wornHistoryList: oldWornHistoryList,
                      expandList: () async => widget.myLensesWM
                          .loadWornHistory(showAll: true, isOld: true),
                    ),
                  ),
              ]),
            ),
          ),
      ],
    );
  }
}
