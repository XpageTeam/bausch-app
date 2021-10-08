import 'package:bausch/models/catalog_item_model.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/button_with_points_content.dart';
import 'package:flutter/material.dart';

class TopSection extends StatelessWidget {
  final CatalogItemModel model;
  final Widget leftIcon;
  final bool isFull;
  final bool withPrice;
  const TopSection({
    required this.model,
    required this.leftIcon,
    required this.isFull,
    required this.withPrice,
    Key? key,
  }) : super(key: key);

  const TopSection.product(CatalogItemModel model, Widget leftIcon, Key? key)
      : this(
          model: model,
          leftIcon: leftIcon,
          isFull: false,
          withPrice: true,
          key: key,
        );

  TopSection.packaging(CatalogItemModel model, Key? key)
      : this(
          model: model,
          leftIcon: Container(),
          isFull: false,
          withPrice: true,
          key: key,
        );

  TopSection.webinar(CatalogItemModel model, Key? key)
      : this(
          model: model,
          leftIcon: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Image.asset(
              'assets/play-video.png',
              height: 28,
            ),
          ),
          isFull: true,
          withPrice: false,
          key: key,
        );

  const TopSection.consultation(
    CatalogItemModel model,
    Widget leftIcon,
    Key? key,
  ) : this(
          model: model,
          leftIcon: leftIcon,
          isFull: false,
          withPrice: true,
          key: key,
        );

  const TopSection.partners(CatalogItemModel model, Widget leftIcon, Key? key)
      : this(
          model: model,
          leftIcon: leftIcon,
          isFull: true,
          withPrice: true,
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: Stack(
        children: [
          Column(
            children: [
              if (!isFull)
                const SizedBox(
                  height: 64,
                ),
              Image.asset(
                model.img ?? 'assets/woman.png',
                height: !isFull ? MediaQuery.of(context).size.height / 5 : null,
                fit: BoxFit.cover,
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: StaticData.sidePadding,
                ),
                child: Text(
                  model.name,
                  style: AppStyles.h2,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              if (withPrice)
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 30,
                  ),
                  child: ButtonContent(price: model.price),
                ),
            ],
          ),
          CustomSliverAppbar(
            iconColor: AppTheme.mystic,
            icon: leftIcon,
          ),
        ],
      ),
    );
  }
}
