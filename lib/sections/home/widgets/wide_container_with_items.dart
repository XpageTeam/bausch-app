import 'package:bausch/models/sheets/sheet_with_items_model.dart';
import 'package:bausch/sections/sheets/sheet_methods.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class WideContainerWithItems extends StatelessWidget {
  final List<String>? children;
  final String? subtitle;
  final SheetModelWithItems sheetModel;
  const WideContainerWithItems({
    required this.sheetModel,
    this.children,
    this.subtitle,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showSheetWithItems(context, sheetModel);
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
}
