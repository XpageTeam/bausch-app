import 'package:bausch/models/catalog_item/catalog_item_model.dart';
import 'package:bausch/sections/home/widgets/containers/white_container_with_rounded_corners.dart';
import 'package:bausch/sections/sheets/product_sheet/info_section.dart';
import 'package:bausch/sections/sheets/sheet_screen.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/sections/sheets/widgets/warning_widget.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/button_with_points_content.dart';
import 'package:bausch/widgets/buttons/floatingactionbutton.dart';
import 'package:bausch/widgets/text/text_with_point.dart';
import 'package:flutter/material.dart';

//catalog_partners
class PartnersScreen extends StatelessWidget {
  final ScrollController controller;
  final CatalogItemModel model;
  const PartnersScreen({
    required this.controller,
    required this.model,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(5),
        topRight: Radius.circular(5),
      ),
      child: Scaffold(
        backgroundColor: AppTheme.mystic,
        body: CustomScrollView(
          controller: controller,
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 12, right: 12, top: 12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              //* Проверка, растягивать ли изображение на всё доступное пространство

                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  topRight: Radius.circular(5),
                                ),
                                child: Image.asset(
                                  'assets/temp/image.png',
                                  //height: null,
                                  fit: BoxFit.cover,
                                ),
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

                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 30,
                                ),
                                child: ButtonContent(price: '${model.price}'),
                              ),
                            ],
                          ),
                          CustomSliverAppbar.toPop(
                            icon: Container(),
                            key: key,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 12,
                              top: 14,
                            ),
                            child: Image.asset(
                              'assets/partners/more_logo.png',
                              height: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 4,
                        ),
                        // InfoSection(
                        //   text: model.previewText,
                        //   secondText: model.detailText,
                        // ),
                        WhiteContainerWithRoundedCorners(
                          padding: const EdgeInsets.fromLTRB(
                            StaticData.sidePadding,
                            20,
                            StaticData.sidePadding,
                            40,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                model.previewText,
                                style: AppStyles.p1,
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              Text(
                                'Как воспользоваться промокодом',
                                style: AppStyles.h2,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: TextWithPoint(
                                  text:
                                      'После того, как вы выберите промокод, он будет храниться в личном кабинете. Ещё мы продублируем его вам на почту.',
                                  dotStyle: AppStyles.p1,
                                  textStyle: AppStyles.p1,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: TextWithPoint(
                                  text:
                                      'Активировать промокод вы сможете в любое время на сайте More.TV в разделе «Использовать ромокод»',
                                  dotStyle: AppStyles.p1,
                                  textStyle: AppStyles.p1,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: TextWithPoint(
                                  text:
                                      'Если вы используете мобильное приложение, войдите в профиль, используя те же данные пользователя.',
                                  dotStyle: AppStyles.p1,
                                  textStyle: AppStyles.p1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: AppTheme.sulu,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 17,
                              bottom: 30,
                              right: StaticData.sidePadding,
                              left: StaticData.sidePadding,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Онлайн-кинотеатр',
                                  style: AppStyles.h1,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'more.tv',
                                  style: AppStyles.p1Underlined,
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                Text(
                                  'Скачайте приложение и смотрите любимые фильмы в любое время',
                                  style: AppStyles.p1,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: CustomFloatingActionButton(
          text: 'Получить поощрение ${model.price} б',
          withInfo: false,
          icon: Container(),
          onPressed: () {
            Keys.bottomSheetItemsNav.currentState!.pushNamed(
              '/verification_partners',
              arguments: SheetScreenArguments(model: model),
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
