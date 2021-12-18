import 'package:bausch/models/add_item_model.dart';
import 'package:bausch/sections/sheets/widgets/custom_sheet_scaffold.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/buttons/button_with_points_content.dart';
import 'package:bausch/widgets/buttons/normal_icon_button.dart';
import 'package:bausch/widgets/select_widgets/custom_radio.dart';
import 'package:flutter/material.dart';

class SurveyScreen extends StatefulWidget {
  final ScrollController controller;
  final AddItemModel model;
  const SurveyScreen({
    required this.controller,
    required this.model,
    Key? key,
  }) : super(key: key);

  @override
  State<SurveyScreen> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  int page = 1;

  List<String> variants = [
    'Да, оформил(а) и получил(а) свою первую пару зинз бесплатно в оптике',
    'Да, но я не нашел(ла) времени активировать его и срок действия истёк ',
    'Да, но у меня возникли трудности с его активацией',
    'Я знаю про такую возможность,но не оформлял(а)',
    'Нет, я  впервые об этом слышу',
  ];

  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return CustomSheetScaffold(
      controller: widget.controller,
      appBar: const CustomSliverAppbar(
        padding: EdgeInsets.all(18),
        iconColor: AppTheme.mystic,
      ),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(12),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                //* Верхний контейнер
                if (page == 1)
                  Container(
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
                              widget.model.img,
                              fit: BoxFit.cover,
                              height: 200,
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: StaticData.sidePadding,
                              ),
                              child: Text(
                                widget.model.title,
                                style: AppStyles.h1,
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
                              child: ButtonContent(
                                price: widget.model.priceString,
                                textStyle: AppStyles.h1,
                              ),
                            ),
                          ],
                        ),
                        // CustomSliverAppbar.toPop(
                        //   icon: NormalIconButton(
                        //     onPressed: () {
                        //       Navigator.of(context).pop();
                        //     }, //Navigator.of(context).pop,
                        //     backgroundColor: AppTheme.mystic,
                        //     icon: const Icon(
                        //       Icons.chevron_left_rounded,
                        //       size: 20,
                        //       color: AppTheme.mineShaft,
                        //     ),
                        //   ),
                        //   key: widget.key,
                        //   rightKey: Keys.simpleBottomSheetNav,
                        // ),
                      ],
                    ),
                  ),

                Padding(
                  padding: const EdgeInsets.only(
                    top: 27,
                    bottom: 4,
                  ),
                  child: Text(
                    'Оформляли ли вы Сертификат на бесплатную пару линз Bausch+Lonm?',
                    style: AppStyles.h2,
                  ),
                ),

                Text(
                  '1/10',
                  style: AppStyles.h3,
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.only(
            top: 18,
            left: 12,
            right: 12,
          ),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) {
                return Padding(
                  padding: const EdgeInsets.only(
                    bottom: 4,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: const EdgeInsets.only(
                      top: 12,
                      left: 12,
                      right: 12,
                      bottom: 20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            variants[i],
                            style: AppStyles.h3,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        CustomRadio(
                          value: i,
                          groupValue: _selected,
                          onChanged: (v) {
                            setState(
                              () {
                                _selected = i;
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
              childCount: variants.length,
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.only(
            left: 12,
            right: 12,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: const EdgeInsets.all(StaticData.sidePadding),
                  child: TextField(
                    controller: TextEditingController(),
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'Добавить свой вариант',
                      hintStyle: AppStyles.h3,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                BlueButtonWithText(
                  text: 'Далее',
                  onPressed: () {
                    setState(() {
                      page += 1;
                    });
                  },
                ),
                const SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
