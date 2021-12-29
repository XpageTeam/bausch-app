import 'package:bausch/models/add_points/quiz/quiz_model.dart';
import 'package:bausch/sections/sheets/widgets/custom_sheet_scaffold.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/buttons/button_with_points_content.dart';
import 'package:bausch/widgets/select_widgets/custom_radio.dart';
import 'package:flutter/material.dart';

class QuizScreenArguments {
  final QuizModel model;

  QuizScreenArguments({
    required this.model,
  });
}

class QuizScreen extends StatefulWidget implements QuizScreenArguments {
  final ScrollController controller;
  @override
  final QuizModel model;
  const QuizScreen({
    required this.controller,
    required this.model,
    Key? key,
  }) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int page = 0;

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
      resizeToAvoidBottomInset: false,
      appBar: const CustomSliverAppbar(
        padding: EdgeInsets.all(18),
        iconColor: AppTheme.mystic,
      ),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            StaticData.sidePadding,
            StaticData.sidePadding,
            StaticData.sidePadding,
            27,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                //* Верхний контейнер
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
                          Image.network(
                            widget.model.detailModel.icon,
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
                              widget.model.detailModel.title,
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
                              price: '+${widget.model.reward}',
                              textStyle: AppStyles.h1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.only(
            left: StaticData.sidePadding,
            right: StaticData.sidePadding,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 4,
                  ),
                  child: Text(
                    widget.model.content[page].title,
                    style: AppStyles.h2,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 30,
                  ),
                  child: Text(
                    '${page + 1}/${widget.model.content.length}',
                    style: AppStyles.h3,
                  ),
                ),
                Column(
                  children: List.generate(
                    widget.model.content[page].answers.length,
                    (i) {
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
                                  widget.model.content[page].answers[i].title,
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
                  ),
                ),
                if (widget.model.content[page].other != null)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    margin: const EdgeInsets.only(
                      bottom: 4,
                    ),
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
                    child: TextField(
                      controller: TextEditingController(),
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: widget.model.content[page].other!.title,
                        hintStyle: AppStyles.h3,
                      ),
                    ),
                  ),
              ],
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
                // Container(
                //   decoration: BoxDecoration(
                //     color: Colors.white,
                //     borderRadius: BorderRadius.circular(5),
                //   ),
                //   padding: const EdgeInsets.all(StaticData.sidePadding),
                //   child: TextField(
                //     controller: TextEditingController(),
                //     maxLines: 5,
                //     decoration: InputDecoration(
                //       hintText: 'Добавить свой вариант',
                //       hintStyle: AppStyles.h3,
                //     ),
                //   ),
                // ),
                // const SizedBox(
                //   height: 40,
                // ),
                BlueButtonWithText(
                  text: 'Далее',
                  onPressed: () {
                    if (page < widget.model.content.length - 1) {
                      setState(() {
                        _selected = 0;
                        page += 1;
                      });
                    }
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
