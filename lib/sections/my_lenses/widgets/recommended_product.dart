import 'package:bausch/models/my_lenses/recommended_products_list_modul.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/grey_button.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

// TODO(pavlov): у слайдера этого виджета внизу должен быть прогресс бар
// такой уже где-то есть?
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
              Padding(
                padding: const EdgeInsets.all(StaticData.sidePadding),
                child: Expanded(
                  child: GreyButton(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    text: 'Где купить',
                    onPressed: () async {
                      if (await canLaunchUrlString(product.link)) {
                        await launchUrlString(
                          product.link,
                          mode: LaunchMode.externalApplication,
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
