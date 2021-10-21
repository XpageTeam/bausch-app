import 'package:bausch/sections/home/sections/may_be_interesting_section.dart';
import 'package:bausch/sections/sheets/product_sheet/info_section.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/bottom_info_block.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/buttons/white_button.dart';
import 'package:bausch/widgets/inputs/default_text_input.dart';
import 'package:bausch/widgets/select_widgets/custom_radio.dart';
import 'package:flutter/material.dart';

//Program
class ProgramScreen extends StatefulWidget {
  final ScrollController controller;
  const ProgramScreen({required this.controller, Key? key}) : super(key: key);

  @override
  State<ProgramScreen> createState() => _ProgramScreenState();
}

class _ProgramScreenState extends State<ProgramScreen> {
  TextEditingController nameController = TextEditingController();
  int gValue = 0;

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
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
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.only(
                top: StaticData.sidePadding,
                left: StaticData.sidePadding,
                right: StaticData.sidePadding,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Stack(
                      children: [
                        Image.asset('assets/program.png'),
                        CustomSliverAppbar.toClose(Container(), widget.key),
                      ],
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    InfoSection(),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 40,
                      ),
                      child: MayBeInteresting(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 40,
                      ),
                      child: InfoSection(),
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
                    const Text(
                      'Ваши данные',
                      style: AppStyles.h1,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    DefaultTextInput(
                      labelText: 'Имя',
                      controller: nameController,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    DefaultTextInput(
                      labelText: 'Фамилия',
                      controller: nameController,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    DefaultTextInput(
                      labelText: 'E-mail',
                      controller: nameController,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        top: 40,
                        bottom: 20,
                      ),
                      child: Text(
                        'Оформляли ли вы Сертификат на бесплатную пару линз Bausch+Lomb?',
                        style: AppStyles.h1,
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
                delegate: SliverChildBuilderDelegate(
                  (context, index) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          gValue = index;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: StaticData.sidePadding,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Flexible(
                              child: Text(
                                'Контактные линзы Bousch+LombКонтактные линзы Bousch+LombКонтактные линзы Bousch+LombКонтактные линзы Bousch+Lomb ',
                                style: AppStyles.h3,
                                maxLines: 3,
                              ),
                            ),
                            CustomRadio(
                              value: index,
                              groupValue: gValue,
                              onChanged: (v) {
                                setState(
                                  () {
                                    gValue = index;
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  childCount: 5,
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
                    const SizedBox(
                      height: 24,
                    ),
                    const WhiteButton(text: 'Выбрать оптику'),
                    const SizedBox(
                      height: 160,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: StaticData.sidePadding,
              ),
              child: BlueButtonWithText(
                text: 'Получить сертификат',
                onPressed: () {},
              ),
            ),
            const InfoBlock(),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
