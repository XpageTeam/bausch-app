import 'package:bausch/packages/bottom_sheet/src/widgets/flexible_draggable_scrollable_sheet.dart';
import 'package:bausch/sections/home/widgets/containers/white_container_with_rounded_corners.dart';
import 'package:bausch/sections/sheets/widgets/custom_sheet_scaffold.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';
class ChooseProductSheet extends StatelessWidget {
  final FlexibleDraggableScrollableSheetScrollController  controller;
  const ChooseProductSheet({required this.controller, Key? key}) : super(key: key);

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
                  child: WhiteContainerWithRoundedCorners(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: StaticData.sidePadding,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Продукт',
                                  style: AppStyles.h2,
                                ),
                                Text(
                                  'срок действия',
                                  style: AppStyles.p1,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 100,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              childCount: 10,
            ),
          ),
        ),
      ],
    );
  }
}
