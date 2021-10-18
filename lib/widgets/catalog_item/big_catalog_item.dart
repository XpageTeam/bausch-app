import 'package:bausch/models/catalog_item_model.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/button_with_points_content.dart';
import 'package:flutter/material.dart';

class BigCatalogItem extends StatelessWidget {
  final CatalogItemModel model;
  const BigCatalogItem({required this.model, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.only(
        top: 20,
        bottom: 26,
        left: StaticData.sidePadding,
        right: StaticData.sidePadding,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.name,
                  style: AppStyles.h2,
                ),
                const SizedBox(
                  height: 4,
                ),
                ButtonContent(
                  price: model.price,
                  alignment: MainAxisAlignment.start,
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 4,
          ),
          Image.asset(
            model.img ?? 'assets/free-packaging.png',
            height: 100,
          ),
        ],
      ),
    );
  }
}
