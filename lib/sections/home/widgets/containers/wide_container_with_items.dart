// ignore_for_file: unused_import

import 'package:bausch/models/sheets/catalog_sheet_with_logos.dart';
import 'package:bausch/sections/home/widgets/containers/container_interface.dart';
import 'package:bausch/sections/home/widgets/containers/white_container_with_rounded_corners.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WideContainerWithItems extends StatelessWidget
    implements ContainerInterface {
  final String? subtitle;

  @override
  final CatalogSheetWithLogosModel model;

  const WideContainerWithItems({
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
              const SizedBox(
                width: 20,
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
          if (model.logos != null)
            Center(
              child: SizedBox(
                height: 32,
                child: ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, i) {
                    return Image.network(
                      model.logos![i],
                      width: 100,
                    );
                  },
                  separatorBuilder: (context, i) {
                    return const VerticalDivider();
                  },
                  itemCount: model.logos!.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

//const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
