import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:bausch/models/sheets/catalog_sheet_model.dart';
import 'package:bausch/models/sheets/sheet_with_items_model.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SmallContainer extends StatelessWidget {
  final CatalogSheetModel model;
  const SmallContainer({
    required this.model,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
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
                model.name,
                style: AppStyles.h1,
                maxLines: 2,
                overflow: TextOverflow.visible,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    model.count.toString(),
                    style: AppStyles.p1,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(6.6),
                    child: SvgPicture.network(
                      model.icon,
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
}
