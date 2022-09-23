import 'package:bausch/models/my_lenses/recommended_products_list_modul.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/button_with_points.dart';
import 'package:bausch/widgets/custom_line_loading.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class RecommendedProduct extends StatelessWidget {
  final RecommendedProductModel product;
  const RecommendedProduct({required this.product, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.only(
          //right: 4,
          bottom: 4,
        ),
        child: Container(
          //padding: const EdgeInsets.all(12),
          width: MediaQuery.of(context).size.width / 2 -
              StaticData.sidePadding -
              2,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: 100,
                child: AspectRatio(
                  aspectRatio: 37 / 12,
                  child: ExtendedImage.network(
                    product.image,
                    printError: false,
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: StaticData.sidePadding,
                ),
                child: Text(
                  product.name,
                  style: AppStyles.p1,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // TODO(wait): переделать когда будет бек
              CustomLineLoadingIndicator(
                maximumScore: 13000,
                isInList: true,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: StaticData.sidePadding,
                  right: StaticData.sidePadding,
                  left: StaticData.sidePadding,
                ),
                // TODO(wait): переделать когда будет бек
                child: ButtonWithPoints(
                  price: '13000',
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
