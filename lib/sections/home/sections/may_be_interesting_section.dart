import 'package:bausch/custom_slideshow.dart';
import 'package:bausch/test/models.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/catalog_item/catalog_item.dart';
import 'package:flutter/material.dart';

class MayBeInteresting extends StatelessWidget {
  const MayBeInteresting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Вам может быть интересно',
          style: AppStyles.h1,
        ),
        const SizedBox(
          height: 20,
        ),
        CustomImageSlideshow(
          height: MediaQuery.of(context).size.height / 2.5,
          indicatorBackgroundColor: Colors.white,
          indicatorColor: AppTheme.turquoiseBlue,
          children: List.generate(
              (Models.items.length % 2) == 0
                  ? Models.items.length ~/ 2
                  : Models.items.length ~/ 2 + 1,
              (i) => Row(
                    children: [
                      CatalogItem(
                        model: Models.items[i * 2],
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      if (Models.items.asMap().containsKey(i * 2 + 1))
                        CatalogItem(model: Models.items[i * 2 + 1])
                    ],
                  )),
        ),
      ],
    );
  }
}
