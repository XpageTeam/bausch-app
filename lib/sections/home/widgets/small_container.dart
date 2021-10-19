import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:bausch/models/sheets/sheet_with_items_model.dart';
import 'package:bausch/navigation/overlay_navigation_with_items.dart';
import 'package:bausch/navigation/overlay_navigation_with_items.dart';
import 'package:bausch/sections/sheets/sheet.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';

class SmallContainer extends StatelessWidget {
  final SheetModelWithItems sheetModel;
  const SmallContainer({
    required this.sheetModel,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showSheet(context, sheetModel);
      },
      child: Container(
        width:
            MediaQuery.of(context).size.width / 2 - StaticData.sidePadding - 2,
        height:
            MediaQuery.of(context).size.width / 2 - StaticData.sidePadding - 2,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 20,
            bottom: 14,
            left: StaticData.sidePadding,
            right: StaticData.sidePadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AutoSizeText(
                sheetModel.title,
                style: AppStyles.h1,
                maxLines: 2,
                overflow: TextOverflow.visible,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    '1',
                    style: AppStyles.p1,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(6.6),
                    child: Image.asset(
                      sheetModel.img!,
                      height: 50,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showSheet(BuildContext context, SheetModelWithItems model) {
    showFlexibleBottomSheet<void>(
      useRootNavigator: true,
      minHeight: 0,
      initHeight: calculatePercentage(model.models!.length),
      maxHeight: 0.95,
      anchors: [0, 0.6, 0.95],
      context: context,
      builder: (context, controller, d) {
        return SheetWidget(
          child: OverlayNavigationWithItems(
            sheetModel: model,
            controller: controller,
          ),
        );
      },
    );
  }

  double calculatePercentage(int lenght) {
    switch (lenght ~/ 2) {
      case 1:
        return 0.5;
      case 2:
        return 0.8;
      default:
        return 0.9;
    }
  }
}
