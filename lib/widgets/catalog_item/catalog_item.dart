import 'package:bausch/models/catalog_item_model.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/button_with_points.dart';
import 'package:bausch/widgets/discount_info.dart';
import 'package:flutter/material.dart';

class CatalogItem extends StatelessWidget {
  final Widget view;
  final CatalogItemModel model;
  final BuildContext context;
  const CatalogItem(this.view, this.context, {required this.model, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return view;
  }

  static CatalogItem product(
    BuildContext context, {
    required CatalogItemModel model,
    required SheetType type,
  }) {
    return CatalogItem(
        InkWell(
          onTap: () {
            switch (type) {
              case SheetType.discountOptics:
                Utils.bottomSheetNav.currentState!.pushNamed(
                  '/discount_optics',
                );
                break;
              case SheetType.webinar:
                // TODO: Handle this case.
                break;
              case SheetType.packaging:
                Utils.bottomSheetNav.currentState!.pushNamed(
                  '/free_packaging',
                );
                break;
              case SheetType.discountOnline:
                Utils.bottomSheetNav.currentState!.pushNamed(
                  '/discount_online',
                );
                break;
              case SheetType.partners:
                Utils.bottomSheetNav.currentState!.pushNamed(
                  '/partners',
                );
                break;
              case SheetType.consultations:
                // TODO: Handle this case.
                break;
            }
          },
          child: Padding(
            padding: const EdgeInsets.only(
              //right: 4,
              bottom: 4,
            ),
            child: Container(
              padding: const EdgeInsets.all(12),
              width: MediaQuery.of(context).size.width / 2 -
                  StaticData.sidePadding -
                  2,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: 100,
                            child: AspectRatio(
                                aspectRatio: 37 / 12,
                                child: Image.asset(
                                  model.img ?? 'assets/free-packaging.png',
                                )),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            model.name,
                            style: AppStyles.p1,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                        ],
                      ),
                      ButtonWithPoints(
                        price: model.price,
                      ),
                    ],
                  ),
                  DiscountInfo(text: '–500 ₽'),
                ],
              ),
            ),
          ),
        ),
        context,
        model: model);
  }

  static CatalogItem webinar(
    BuildContext context, {
    required CatalogItemModel model,
  }) {
    return CatalogItem(
        InkWell(
          onTap: () {
            Utils.bottomSheetNav.currentState!.pushNamed('/webinar');
          },
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
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          AspectRatio(
                              aspectRatio: 174 / 112,
                              child: Image.asset(
                                'assets/woman.png',
                              )),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            model.name,
                            style: AppStyles.p1,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: StaticData.sidePadding,
                          left: StaticData.sidePadding,
                          right: StaticData.sidePadding,
                        ),
                        child: ButtonWithPoints(
                          price: model.price,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(StaticData.sidePadding),
                    child: Image.asset(
                      'assets/play-video.png',
                      height: 28,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        context,
        model: model);
  }
}
