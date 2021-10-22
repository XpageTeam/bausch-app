import 'package:bausch/models/catalog_item_model.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/button_with_points.dart';
import 'package:bausch/widgets/discount_info.dart';
import 'package:flutter/material.dart';

class CatalogItem extends StatelessWidget {
  final CatalogItemModel model;
  final VoidCallback? onTap;
  final bool isProduct;
  const CatalogItem({
    required this.model,
    required this.isProduct,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
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
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      if (isProduct)
                        SizedBox(
                          height: 100,
                          child: AspectRatio(
                            aspectRatio: 37 / 12,
                            child: Image.asset(
                              model.img ?? 'assets/free-packaging.png',
                            ),
                          ),
                        )
                      else
                        AspectRatio(
                          aspectRatio: 174 / 112,
                          child: Image.asset('assets/woman.png'),
                        ),
                      const SizedBox(
                        height: 8,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: StaticData.sidePadding,
                        ),
                        child: Text(
                          model.name,
                          style: AppStyles.p1,
                          textAlign: TextAlign.center,
                          maxLines: 3,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: StaticData.sidePadding,
                      right: StaticData.sidePadding,
                      left: StaticData.sidePadding,
                    ),
                    child: ButtonWithPoints(
                      price: model.price,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: isProduct
                    ? const DiscountInfo(text: '–500 ₽')
                    : Image.asset(
                        'assets/play-video.png',
                        height: 28,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
