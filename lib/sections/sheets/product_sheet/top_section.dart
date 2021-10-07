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
  final Widget view;
  const TopSection({required this.model, required this.view, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return view;
  }

  static TopSection product(CatalogItemModel model, BuildContext context) {
    return TopSection(
      model: model,
      view: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
        ),
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 64,
                ),
                Image.asset(
                  model.img ?? 'assets/woman.png',
                  height: MediaQuery.of(context).size.height / 5,
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
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 30,
                  ),
                  child: ButtonContent(price: model.price),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: PointsInfo(text: 'Не хватает 2000'),
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
      ),
    );
  }

  static TopSection webinar(CatalogItemModel model, BuildContext context) {
    return TopSection(
        model: model,
        view: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  Image.asset(
                    model.img ?? 'assets/woman.png',
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: StaticData.sidePadding,
                      vertical: 30,
                    ),
                    child: Text(
                      model.name,
                      style: AppStyles.h2,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Image.asset(
                      'assets/play-video.png',
                      height: 28,
                    ),
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
        ));
  }

  static TopSection parners(CatalogItemModel model, BuildContext context) {
    return TopSection(
        model: model,
        view: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  Image.asset(
                    model.img ?? 'assets/woman.png',
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: StaticData.sidePadding,
                      vertical: 30,
                    ),
                    child: Text(
                      model.name,
                      style: AppStyles.h2,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const ButtonContent(price: '50'),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
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
        ));
  }
}
