import 'package:bausch/sections/home/sections/may_be_interesting_section.dart';
import 'package:bausch/sections/home/small_container.dart';
import 'package:bausch/sections/home/sections/spend_scores_section.dart';
import 'package:bausch/sections/home/wide_container.dart';
import 'package:bausch/sections/home/widgets/offer_widget.dart';
import 'package:bausch/sections/home/sections/profile_status_section.dart';
import 'package:bausch/sections/home/sections/scores_section.dart';
import 'package:bausch/sections/home/widgets/stories/stories_slider.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/test/models.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/floatingactionbutton.dart';
import 'package:bausch/widgets/buttons/text_button.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.mystic,
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
                  const [ProfileStatus()],
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
                  [OfferWidget()],
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
                  [
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
                    const MayBeInteresting(),
                    const CustomTextButton(title: 'Правила программы'),
                    const CustomTextButton(title: 'Частые вопросы'),
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
      floatingActionButton: CustomFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
