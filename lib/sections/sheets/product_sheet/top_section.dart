import 'package:bausch/models/catalog_item/catalog_item_model.dart';
import 'package:bausch/models/catalog_item/consultattion_item_model.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/button_with_points_content.dart';
import 'package:flutter/material.dart';

class TopSection extends StatelessWidget {
  final CatalogItemModel model;
  final bool isFull;
  final bool withPrice;
  final Widget appBar;
  const TopSection({
    required this.model,
    required this.isFull,
    required this.withPrice,
    required this.appBar,
    Key? key,
  }) : super(key: key);

  TopSection.product(CatalogItemModel model, Widget leftIcon, Key? key)
      : this(
          model: model,
          isFull: false,
          withPrice: true,
          key: key,
          appBar: CustomSliverAppbar.toPop(icon: leftIcon, key: key),
        );

  TopSection.packaging(
      {required CatalogItemModel model, required Widget leftIcon, Key? key})
      : this(
          model: model,
          isFull: false,
          withPrice: true,
          key: key,
          appBar: CustomSliverAppbar.toPop(icon: leftIcon, key: key),
        );

  TopSection.webinar(CatalogItemModel model, Key? key)
      : this(
          model: model,
          isFull: true,
          withPrice: false,
          key: key,
          appBar: CustomSliverAppbar.toPop(
            icon: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Image.asset(
                'assets/play-video.png',
                height: 28,
              ),
            ),
            key: key,
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
          appBar: CustomSliverAppbar.toClose(leftIcon, key),
        );

  // ignore: avoid_unused_constructor_parameters
  TopSection.partners(CatalogItemModel model, Widget leftIcon, Key? key)
      : this(
          model: model,
          isFull: true,
          withPrice: true,
          key: key,
          appBar: CustomSliverAppbar.toPop(icon: Container(), key: key),
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
              //* Проверка, растягивать ли изображение на всё доступное пространство
              if (!isFull)
                const SizedBox(
                  height: 64,
                ),
              Image.network(
                model.picture,
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
                  child: ButtonContent(price: model.price.toString()),
                ),
            ],
          ),
          appBar,
        ],
      ),
    );
  }
}
