import 'package:bausch/models/sheet_model.dart';
import 'package:bausch/navigation/overlay_navigation.dart';
import 'package:bausch/sections/sheets/sheet.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';

class WideContainer extends StatelessWidget {
  final List<String>? children;
  final String? subtitle;
  final SheetModel sheetModel;
  const WideContainer({
    required this.sheetModel,
    this.children,
    this.subtitle,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showSheet(context, sheetModel);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                sheetModel.title,
                style: AppStyles.h2Bold,
              ),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      subtitle ??
                          'Скидка на выбранный товар будет дейстовать в любой из оптик сети',
                      style: AppStyles.p1,
                    ),
                  ),
                  Image.asset(
                    sheetModel.img ?? 'assets/webinar-rec.png',
                    height: 40,
                  ),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              if (children != null)
                Center(
                  child: SizedBox(
                    height: 32,
                    child: ListView.separated(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, i) {
                        return Image.asset(
                          children![i],
                          width: 100,
                        );
                      },
                      separatorBuilder: (context, i) {
                        return const VerticalDivider();
                      },
                      itemCount: children!.length,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void showSheet(BuildContext context, SheetModel model) {
    showFlexibleBottomSheet<void>(
      useRootNavigator: true,
      minHeight: 0,
      initHeight: calculatePercentage(model.models.length),
      maxHeight: 0.95,
      anchors: [0, 0.6, 0.95],
      context: context,
      builder: (context, controller, d) {
        return SheetWidget(
          child: OverlayNavigation(
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
