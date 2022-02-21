import 'package:bausch/models/catalog_item/catalog_item_model.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/button_with_points_content.dart';
import 'package:extended_image/extended_image.dart';
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
                  price: model.priceToString,
                  alignment: MainAxisAlignment.start,
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 4,
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 100,
              maxHeight: 100,
            ),
            child: AspectRatio(
              aspectRatio: 100 / 100,
              child: model.picture != null
                  ? ExtendedImage.network(
                      model.picture!,
                      printError: false,
                      loadStateChanged: loadStateChangedFunction,
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
