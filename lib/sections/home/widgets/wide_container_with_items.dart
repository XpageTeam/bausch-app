import 'package:bausch/models/sheets/sheet_with_items_model.dart';
import 'package:bausch/sections/sheets/sheet_methods.dart';
import 'package:bausch/theme/app_theme.dart';
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
                    child: Row(
                      children: [
                        Flexible(
                          flex: 3,
                          child: Image.asset(
                            children![0],
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Container(
                              color: AppTheme.mystic,
                              width: 2,
                              height: 32,
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 3,
                          child: Image.asset(
                            children![1],
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Container(
                              color: AppTheme.mystic,
                              width: 2,
                              height: 32,
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 3,
                          child: Image.asset(
                            children![2],
                          ),
                        ),
                      ],
                    ),
                    // child: ListView.separated(
                    //   shrinkWrap: true,
                    //   physics: const NeverScrollableScrollPhysics(),
                    //   scrollDirection: Axis.horizontal,
                    //   itemBuilder: (context, i) {
                    //     return Image.asset(
                    //       children![i],
                    //       fit
                    //     );
                    //   },
                    //   separatorBuilder: (context, i) {
                    //     return const VerticalDivider(
                    //       color: AppTheme.mystic,
                    //       width: 2,
                    //     );
                    //   },
                    //   itemCount: children!.length,
                    // ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
