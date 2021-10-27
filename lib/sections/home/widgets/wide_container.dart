import 'package:bausch/models/sheets/base_catalog_sheet_model.dart';
import 'package:bausch/models/sheets/catalog_sheet_without_logos_model.dart';
import 'package:bausch/sections/sheets/sheet_methods.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class WideContainerWithoutItems extends StatelessWidget {
  final List<String>? children;
  final String? subtitle;
  final BaseCatalogSheetModel model;
  const WideContainerWithoutItems({
    required this.model,
    this.children,
    this.subtitle,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //showSheetWithoutItems(context, model);
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
                model.name,
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
                  Image.network(
                    model.icon,
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
