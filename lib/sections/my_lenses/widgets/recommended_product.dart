import 'package:bausch/models/my_lenses/recommended_products_list_modul.dart';
import 'package:bausch/sections/my_lenses/widgets/sheets/recommended_product_sheet.dart';
import 'package:bausch/sections/sheets/sheet.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/grey_button.dart';
import 'package:bausch/widgets/simple_webview_widget.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class RecommendedProduct extends StatelessWidget {
  final RecommendedProductModel product;
  const RecommendedProduct({required this.product, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await showFlexibleBottomSheet<void>(
          minHeight: 0,
          initHeight: 0.95,
          maxHeight: 0.95,
          anchors: [0, 0.6, 0.95],
          context: context,
          bottomSheetColor: Colors.transparent,
          barrierColor: Colors.black.withOpacity(0.8),
          builder: (context, controller, d) {
            return SheetWidget(
              child: RecommendedProductSheet(
                controller: controller,
                product: product,
              ),
            );
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 4,
        ),
        child: Container(
          width: MediaQuery.of(context).size.width / 2 -
              StaticData.sidePadding -
              2,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          padding: const EdgeInsets.all(12),
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
              Text(
                product.name,
                style: AppStyles.p1,
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              Padding(
                padding: const EdgeInsets.only(top: StaticData.sidePadding),
                child: GreyButton(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  text: 'Где купить',
                  onPressed: () => openSimpleWebView(
                    context,
                    url: product.link,
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
