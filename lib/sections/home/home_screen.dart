import 'package:bausch/main.dart';
import 'package:bausch/models/sheets/simple_sheet_model.dart';
import 'package:bausch/sections/faq/faq_screen.dart';
import 'package:bausch/sections/home/sections/may_be_interesting_section.dart';
import 'package:bausch/sections/home/sections/profile_status_section.dart';
import 'package:bausch/sections/home/sections/scores_section.dart';
import 'package:bausch/sections/home/sections/spend_scores_section.dart';
import 'package:bausch/sections/home/widgets/offer_widget.dart';
import 'package:bausch/sections/home/widgets/stories/stories_slider.dart';
import 'package:bausch/sections/home/widgets/wide_container_with_items.dart';
import 'package:bausch/sections/sheets/sheet_methods.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/test/models.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/widgets/buttons/floatingactionbutton.dart';
import 'package:bausch/widgets/buttons/text_button.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.mystic,
      resizeToAvoidBottomInset: false,
      primary: false,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: StaticData.sidePadding,
                vertical: 14,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  //* Статус пользователя
                  [
                    ProfileStatus(
                      onPressed: () {
                        Keys.mainContentNav.currentState!.pushNamed('/profile');
                      },
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(
                bottom: 20,
                left: StaticData.sidePadding,
                right: StaticData.sidePadding,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  //* Количество баллов
                  const [ScoresSection()],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(
                bottom: 20,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  //* Сторисы
                  [StoriesSlider(items: Models.stories)],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(
                bottom: 20,
                left: StaticData.sidePadding,
                right: StaticData.sidePadding,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  //* Баннер для перехода на экран программы подбора
                  const [OfferWidget()],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(
                bottom: 40,
                left: StaticData.sidePadding,
                right: StaticData.sidePadding,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  const [
                    //* Потратить баллы, тут кнопки для вывода bottomSheet'ов
                    SpendScores(),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(
                bottom: 20,
                left: StaticData.sidePadding,
                right: StaticData.sidePadding,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    //* Вам может быть интересно
                    const MayBeInteresting(),
                    CustomTextButton(
                      title: 'Правила программы',
                      onPressed: () {},
                    ),
                    CustomTextButton(
                      title: 'Частые вопросы',
                      onPressed: () {
                        showSimpleSheet(
                          context,
                          SimpleSheetModel(
                            title: 'Частые вопросы',
                            type: SimpleSheetType.faq,
                          ),
                        );
                      },
                    ),
                    const CustomTextButton(title: 'Библиотека ссылок'),
                    const SizedBox(
                      height: 100,
                    ),
                    Image.asset('assets/logo.png'),
                    const SizedBox(
                      height: 120,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomFloatingActionButton(
        text: 'Добавить баллы',
        onPressed: () {
          showSheetWithoutItems(context, Models.sheets[2]);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
