import 'package:bausch/models/catalog_item_model.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/button_with_points_content.dart';
import 'package:bausch/widgets/catalog_item/catalog_item.dart';
import 'package:bausch/widgets/points_info.dart';
import 'package:flutter/material.dart';

class TopSection extends StatelessWidget {
  final CatalogItemModel model;
  final SheetType type;
  const TopSection({required this.model, required this.type, Key? key})
      : super(key: key);

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
              if (type != SheetType.webinar)
                const SizedBox(
                  height: 64,
                ),
              Image.asset(
                model.img ?? 'assets/woman.png',
                height: type != SheetType.webinar
                    ? MediaQuery.of(context).size.height / 5
                    : null,
                fit: BoxFit.cover,
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: StaticData.sidePadding),
                child: Text(
                  model.name,
                  style: AppStyles.h2,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              if (type != SheetType.webinar) ButtonContent(price: model.price),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (type == SheetType.discountOptics)
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: PointsInfo(text: 'Не хватает 2000'),
                )
              else if (type == SheetType.webinar)
                Padding(
                  padding: EdgeInsets.all(12),
                  child: Image.asset(
                    'assets/play-video.png',
                    height: 28,
                  ),
                )
              else
                SizedBox(
                  width: 10,
                ),
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: CircleAvatar(
                  backgroundColor: AppTheme.mystic,
                  radius: 22,
                  child: IconButton(
                      onPressed: () {
                        Utils.bottomSheetNav.currentState!.pop();
                      },
                      icon: const Icon(
                        Icons.close,
                        color: AppTheme.mineShaft,
                      )),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
