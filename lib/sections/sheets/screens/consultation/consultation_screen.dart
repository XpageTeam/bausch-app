import 'package:bausch/models/catalog_item/catalog_item_model.dart';
import 'package:bausch/models/catalog_item/consultattion_item_model.dart';
import 'package:bausch/sections/home/widgets/containers/white_container_with_rounded_corners.dart';
import 'package:bausch/sections/sheets/product_sheet/info_section.dart';
import 'package:bausch/sections/sheets/product_sheet/top_section.dart';
import 'package:bausch/sections/sheets/sheet_screen.dart';
import 'package:bausch/sections/sheets/widgets/warning_widget.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/floatingactionbutton.dart';
import 'package:bausch/widgets/text/text_with_point.dart';
import 'package:flutter/material.dart';

//catalog_online_consultation
class ConsultationScreen extends StatefulWidget {
  final ScrollController controller;
  final CatalogItemModel item;
  const ConsultationScreen({
    required this.controller,
    required this.item,
    Key? key,
  }) : super(key: key);

  @override
  State<ConsultationScreen> createState() => _ConsultationScreenState();
}

class _ConsultationScreenState extends State<ConsultationScreen> {
  late ConsultationItemModel model;

  @override
  void initState() {
    super.initState();
    model = widget.item as ConsultationItemModel;
  }

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
          controller: widget.controller,
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.only(
                top: 12,
                left: 12,
                right: 12,
                bottom: 4,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    TopSection.consultation(
                      widget.item as ConsultationItemModel,
                      Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/icons/time.png',
                              height: 16,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              '${model.length} минут',
                              style: AppStyles.p1,
                            ),
                          ],
                        ),
                      ),
                      widget.key,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
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
                            'Как воспользоваться промокодом в SmartMed',
                            style: AppStyles.h2,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: TextWithPoint(
                              text:
                                  'В мобильном приложении SmartMed выберите раздел «Еще», затем «Промокоды». Если вы используете сайт, кликните на раздел «Промокоды» в вашем Профиле.',
                              dotStyle: AppStyles.p1,
                              textStyle: AppStyles.p1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: TextWithPoint(
                              text:
                                  'Введите промокод и нажмите «Далее», скидка 100% автоматически применится на консультации дежурного врача или врача по предварительной записи. Т',
                              dotStyle: AppStyles.p1,
                              textStyle: AppStyles.p1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: TextWithPoint(
                              text:
                                  'Затем переходите к выбору врача и времени консультации в разделе «Онлайн-консультация».',
                              dotStyle: AppStyles.p1,
                              textStyle: AppStyles.p1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: StaticData.sidePadding,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Warning.advertisment(
                      name: 'SmartMed',
                      link: 'smartmed.pro',
                      description:
                          'Скачайте приложение и общайтесь с компетентными врачами МЕДСИ, не выходя из дома.',
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: CustomFloatingActionButton(
          text: 'Получить поощрение ${model.price} б',
          onPressed: () {
            Keys.bottomSheetWithoutItemsNav.currentState!.pushNamed(
              '/verification_consultation',
              arguments: SheetScreenArguments(model: model),
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
