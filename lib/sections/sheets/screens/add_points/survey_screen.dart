import 'package:bausch/models/add_item_model.dart';
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
  int _selected = 0;
  int page = 1;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(5),
        topRight: Radius.circular(5),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: CustomScrollView(
          controller: widget.controller,
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
                            CustomSliverAppbar.toPop(
                              icon: NormalIconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                }, //Navigator.of(context).pop,
                                backgroundColor: AppTheme.mystic,
                                icon: const Icon(
                                  Icons.chevron_left_rounded,
                                  size: 20,
                                  color: AppTheme.mineShaft,
                                ),
                              ),
                              key: widget.key,
                              rightKey: Keys.simpleBottomSheetNav,
                            ),
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
                          children: [
                            Flexible(
                              child: Text(
                                'Вариант ответа',
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
                  childCount: 5,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(
                top: 0,
                left: 12,
                right: 12,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Container(
                      height: 100,
                      alignment: Alignment.topRight,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        children: const [
                          Text('Добавить свой вариант'),
                        ],
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
        ),
      ),
    );
  }
}
