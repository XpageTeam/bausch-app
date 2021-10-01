import 'package:bausch/test/models.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/catalog_item/catalog_item.dart';
import 'package:flutter/material.dart';

class Sheet extends StatelessWidget {
  final ScrollController controller;
  final String title;
  const Sheet({required this.title, required this.controller, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(5),
        topRight: Radius.circular(5),
      ),
      child: Scaffold(
        body: CustomScrollView(
          controller: controller,
          slivers: [
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 20,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Row(
                      children: [
                        Image.asset(
                          'assets/free-packaging.png',
                          height: 60,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          title,
                          style: AppStyles.h2,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(
                left: 12,
                right: 12,
                bottom: 40,
              ),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) => IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CatalogItem(
                          model: Models.items[i * 2],
                        ),
                        if (Models.items.asMap().containsKey(i * 2 + 1))
                          CatalogItem(model: Models.items[i * 2 + 1])
                      ],
                    ),
                  ),
                  childCount: (Models.items.length % 2) == 0
                      ? Models.items.length ~/ 2
                      : Models.items.length ~/ 2 + 1,
                ),
              ),
            ),
            SliverList(
                delegate: SliverChildListDelegate([
              const SizedBox(
                height: 60,
                child: Text(
                  'Имеются противопоказания, необходимо проконсультироваться со специалистом',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    height: 16 / 14,
                    color: AppTheme.grey,
                  ),
                ),
              )
            ])),
          ],
        ),
      ),
    );
  }
}
