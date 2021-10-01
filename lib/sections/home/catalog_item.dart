import 'package:bausch/models/catalog_item_model.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/button_with_points.dart';
import 'package:flutter/material.dart';

class CatalogItem extends StatelessWidget {
  final CatalogItemModel model;
  const CatalogItem({required this.model, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: Container(
        padding: const EdgeInsets.all(12),
        width:
            MediaQuery.of(context).size.width / 2 - StaticData.sidePadding - 2,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                SizedBox(
                  height: 100,
                  child: AspectRatio(
                      aspectRatio: 37 / 12,
                      child: Image.asset(
                        model.img ?? 'assets/pic2.png',
                      )),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  model.name,
                  style: AppStyles.p1,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 16,
                ),
              ],
            ),
            ButtonWithPoints(
              price: model.price,
            ),
          ],
        ),
      ),
    );
  }
}
