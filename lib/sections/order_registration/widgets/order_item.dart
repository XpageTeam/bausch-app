import 'package:bausch/models/catalog_item/catalog_item_model.dart';
import 'package:bausch/sections/sheets/white_rounded_container.dart';
import 'package:bausch/static/static_data.dart';
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
        children: [
          //TODO(Nikita): не могу добавить flexible
          SizedBox(
            width: MediaQuery.of(context).size.width * 2 / 3,
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.name,
                  style: AppStyles.h2,
                ),
                ButtonContent(
                  price: model.priceToString,
                  alignment: MainAxisAlignment.start,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 80,
            child: Image.network(
              model.picture!,
            ),
          ),
        ],
      ),
    );
  }
}
