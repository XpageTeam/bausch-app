import 'package:bausch/models/catalog_item/catalog_item_model.dart';
import 'package:bausch/sections/sheets/white_rounded_container.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/button_with_points_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OrderItem extends StatelessWidget {
  final CatalogItemModel model;
  const OrderItem({
    required this.model,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WhiteRoundedContainer(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Column(
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
            width: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 6,
            ),
            child: SizedBox(
              height: 100,
              child: Image.network(
                model.picture!,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
