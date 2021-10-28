// ignore_for_file: unused_import

import 'package:bausch/models/sheets/base_catalog_sheet_model.dart';
import 'package:bausch/models/sheets/catalog_sheet_without_logos_model.dart';
import 'package:bausch/sections/home/widgets/containers/container_interface.dart';
import 'package:bausch/sections/home/widgets/containers/white_container_with_rounded_corners.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class WideContainerWithoutItems extends StatelessWidget
    implements ContainerInterface {
  final String? subtitle;

  @override
  final CatalogSheetWithoutLogosModel model;

  const WideContainerWithoutItems({
    required this.model,
    this.subtitle,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WhiteContainerWithRoundedCorners(
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
        ],
      ),
    );
  }
}
