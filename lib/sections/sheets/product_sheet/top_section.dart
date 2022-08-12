import 'package:bausch/models/catalog_item/catalog_item_model.dart';
import 'package:bausch/models/catalog_item/consultattion_item_model.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/button_with_points_content.dart';
import 'package:bausch/widgets/discount_info.dart';
import 'package:flutter/material.dart';

class TopSection extends StatelessWidget {
  final CatalogItemModel model;
  final bool isFull;
  final bool withPrice;
  final Widget topLeftWidget;
  final String? discount;

  const TopSection({
    required this.model,
    required this.isFull,
    required this.withPrice,
    required this.topLeftWidget,
    this.discount,
    Key? key,
  }) : super(key: key);

  TopSection.product({
    required CatalogItemModel model,
    required String discount,
    Widget? topLeftWidget,
    Key? key,
  }) : this(
          model: model,
          isFull: false,
          withPrice: true,
          key: key,
          discount: discount,
          topLeftWidget: Padding(
            padding: const EdgeInsets.only(left: 12, top: 16),
            child: topLeftWidget,
          ),
        );

  TopSection.packaging({
    required CatalogItemModel model,
    required Widget topLeftWidget,
    Key? key,
  }) : this(
          model: model,
          isFull: false,
          withPrice: true,
          key: key,
          topLeftWidget: Padding(
            padding: const EdgeInsets.only(
              left: 12,
              top: 16,
            ),
            child: topLeftWidget,
          ),
        );

  TopSection.webinar({
    required CatalogItemModel model,
    Widget? topLeftWidget,
    Key? key,
  }) : this(
          model: model,
          isFull: true,
          withPrice: false,
          key: key,
          topLeftWidget: Padding(
            padding: const EdgeInsets.all(12),
            child: topLeftWidget,
          ),
        );

  TopSection.consultation({
    required CatalogItemModel model,
    Widget? topLeftWidget,
    Key? key,
  }) : this(
          model: model,
          isFull: false,
          withPrice: true,
          key: key,
          topLeftWidget: Padding(
            padding: const EdgeInsets.only(
              left: 12,
              top: 16,
            ),
            child: topLeftWidget,
          ),
        );

  // ignore: avoid_unused_constructor_parameters
  TopSection.partners({
    required CatalogItemModel model,
    Widget? topLeftWidget,
    Key? key,
  }) : this(
          model: model,
          isFull: true,
          withPrice: true,
          key: key,
          topLeftWidget: Padding(
            padding: const EdgeInsets.only(
              left: 12,
              top: 16,
            ),
            child: topLeftWidget,
          ),
        );

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: Stack(
        children: [
          Column(
            children: [
              //* Проверка, растягивать ли изображение на всё доступное пространство
              if (!isFull)
                const SizedBox(
                  height: 64,
                ),
              if (model.picture != null)
                Container(
                  height: !isFull ? calculateHeight(model, context) : null,
                  margin: const EdgeInsets.only(bottom: 30),
                  child: Stack(
                    children: [
                      Center(
                        child: Image.network(
                          model.picture!,
                          fit: BoxFit.cover,
                        ),
                      ),
                      // TODO(info): пока заглушкой
                      // если скидка не будет на картинке приходить
                      if (discount != null)
                        Align(
                          alignment: Alignment.bottomRight,
                          child: DiscountInfo(text: discount!),
                        ),
                    ],
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
          topLeftWidget,
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
