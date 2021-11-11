import 'package:bausch/sections/home/sections/may_be_interesting_section.dart';
import 'package:bausch/sections/home/sections/profile_status_section.dart';
import 'package:bausch/sections/home/sections/scores_section.dart';
import 'package:bausch/sections/home/sections/spend_scores_section.dart';
import 'package:bausch/sections/home/sections/text_buttons_section.dart';
import 'package:bausch/sections/home/widgets/offer_widget.dart';
import 'package:bausch/sections/home/widgets/stories/stories_slider.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/widgets/animated_translate_opacity.dart';
import 'package:bausch/widgets/buttons/floatingactionbutton.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.mystic,
      resizeToAvoidBottomInset: false,
      extendBody: true,
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
                  [
                    DelayedAnimatedTranslateOpacity(
                      offsetY: 20,
                      child: ProfileStatus(
                        onPressed: () {
                          Keys.mainContentNav.currentState!
                              .pushNamed('/profile');
                        },
                      ),
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
                  const [
                    DelayedAnimatedTranslateOpacity(
                      offsetY: 30,
                      child: ScoresSection(
                        loadingAnimationDuration: Duration(
                          milliseconds: 2500,
                        ),
                        delay: Duration(
                          milliseconds: 1000,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(
                bottom: 20,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    DelayedAnimatedTranslateOpacity(
                      offsetY: 40,
                      child: StoriesSlider(items: Models.stories),
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
                  const [
                    DelayedAnimatedTranslateOpacity(
                      offsetY: 50,
                      child: OfferWidget(),
                    ),
                  ],
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
                    DelayedAnimatedTranslateOpacity(
                      offsetY: 60,
                      child: SpendScores(),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(
                bottom: 30,
                left: StaticData.sidePadding,
                right: StaticData.sidePadding,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    //* Вам может быть интересно
                    const MayBeInteresting(),

                    //* Текстовые кнопки(Частые вопросы и тд)
                    const TextButtonsSection(),
                    const SizedBox(
                      height: 100,
                    ),
                    Image.asset('assets/logo.png'),
                    const SizedBox(
                      height: 60,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: DelayedAnimatedTranslateOpacity(
        offsetY: 10,
        child: CustomFloatingActionButton(
          text: 'Добавить баллы',
          onPressed: () {
            showSheetWithoutItems(context, Models.sheets[2]);
          },
        ),
        animationDuration: Duration.zero,
      ),
    );
  }
}
