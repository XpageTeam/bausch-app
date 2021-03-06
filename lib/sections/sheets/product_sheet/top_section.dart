import 'package:bausch/models/catalog_item/catalog_item_model.dart';
import 'package:bausch/models/catalog_item/consultattion_item_model.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/button_with_points_content.dart';
import 'package:flutter/material.dart';

class TopSection extends StatelessWidget {
  final CatalogItemModel model;
  final bool isFull;
  final bool withPrice;
  final Widget leftIcon;

  const TopSection({
    required this.model,
    required this.isFull,
    required this.withPrice,
    required this.leftIcon,
    Key? key,
  }) : super(key: key);

  TopSection.product(CatalogItemModel model, Widget leftIcon, Key? key)
      : this(
          model: model,
          isFull: false,
          withPrice: true,
          key: key,
          leftIcon: Padding(
            padding: const EdgeInsets.only(
              left: 12,
              top: 16,
            ),
            child: leftIcon,
          ),
        );

  TopSection.packaging({
    required CatalogItemModel model,
    required Widget leftIcon,
    // GlobalKey<NavigatorState>? rightKey,
    Key? key,
  }) : this(
          model: model,
          isFull: false,
          withPrice: true,
          key: key,
          leftIcon: Padding(
            padding: const EdgeInsets.only(
              left: 12,
              top: 16,
            ),
            child: leftIcon,
          ),
        );

  TopSection.webinar(CatalogItemModel model, Key? key, Widget leftIcon)
      : this(
          model: model,
          isFull: true,
          withPrice: false,
          key: key,
          leftIcon: Padding(
            padding: const EdgeInsets.all(12),
            child: leftIcon,
          ),
        );

  TopSection.consultation(
    ConsultationItemModel model,
    Widget leftIcon,
    Key? key,
  ) : this(
          model: model,
          isFull: false,
          withPrice: true,
          key: key,
          leftIcon: Padding(
            padding: const EdgeInsets.only(
              left: 12,
              top: 16,
            ),
            child: leftIcon,
          ),
        );

  // ignore: avoid_unused_constructor_parameters
  TopSection.partners(CatalogItemModel model, Key? key, Widget leftIcon)
      : this(
          model: model,
          isFull: true,
          withPrice: true,
          key: key,
          leftIcon: Padding(
            padding: const EdgeInsets.only(
              left: 12,
              top: 16,
            ),
            child: leftIcon,
          ),
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
              //* ????????????????, ?????????????????????? ???? ?????????????????????? ???? ?????? ?????????????????? ????????????????????????
              if (!isFull)
                const SizedBox(
                  height: 64,
                ),
              if (model.picture != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 30),
                  child: Image.network(
                    model.picture!,
                    height: !isFull ? calculateHeight(model, context) : null,
                    fit: BoxFit.cover,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: StaticData.sidePadding,
                ),
                child: Text(
                  model.name,
                  style: AppStyles.h1,
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
                  child: ButtonContent(
                    price: model.priceToString,
                    textStyle: AppStyles.h1,
                  ),
                ),
            ],
          ),
          leftIcon,
        ],
      ),
    );
  }

  double calculateHeight(CatalogItemModel model, BuildContext context) {
    if (model is ConsultationItemModel) {
      return MediaQuery.of(context).size.height / 8;
    } else {
      return MediaQuery.of(context).size.height / 5;
    }
  }
}
