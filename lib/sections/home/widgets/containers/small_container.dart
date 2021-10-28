// ignore_for_file: unused_import

import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:bausch/models/sheets/catalog_sheet_model.dart';
import 'package:bausch/sections/home/widgets/containers/container_interface.dart';
import 'package:bausch/sections/home/widgets/containers/white_container_with_rounded_corners.dart';
import 'package:bausch/sections/sheets/sheet_methods.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SmallContainer extends StatelessWidget implements ContainerInterface {
  @override
  final CatalogSheetModel model;
  const SmallContainer({
    required this.model,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _width =
        MediaQuery.of(context).size.width / 2 - StaticData.sidePadding - 2;

    return WhiteContainerWithRoundedCorners(
      onTap: () {
        showSheetWithItems(context, model);
      },
      heigth: _width,
      width: _width,
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
                child: Image.network(
                  model.icon,
                  height: 50,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
