import 'package:bausch/models/my_lenses/lenses_pair_model.dart';
import 'package:bausch/sections/my_lenses/my_lenses_wm.dart';
import 'package:bausch/sections/my_lenses/widgets/pages/current_daily_lenses_page.dart';
import 'package:bausch/sections/my_lenses/widgets/pages/current_multi_lenses_page.dart';
import 'package:bausch/sections/my_lenses/widgets/pages/lenses_page_switcher.dart';
import 'package:bausch/sections/my_lenses/widgets/pages/old_lenses_page.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/widgets/anti_glow_behavior.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:bausch/widgets/loader/animated_loader.dart';
import 'package:bausch/widgets/only_bottom_bouncing_scroll_physics.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class MyLensesScreen extends CoreMwwmWidget<MyLensesWM> {
  final MyLensesWM myLensesWM;
  MyLensesScreen({required this.myLensesWM, Key? key})
      : super(
          key: key,
          widgetModelBuilder: (context) => myLensesWM,
        );

  @override
  WidgetState<CoreMwwmWidget<MyLensesWM>, MyLensesWM> createWidgetState() =>
      _MyLensesScreenState();
}

class _MyLensesScreenState extends WidgetState<MyLensesScreen, MyLensesWM> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar(
        title: 'Мои линзы',
        backgroundColor: AppTheme.mystic,
        backIcon: Icons.home_filled,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: StaticData.sidePadding,
            ),
            child: LensesPageSwitcher(myLensesWM: wm),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: CustomScrollView(
              scrollBehavior: const AntiGlowBehavior(),
              physics: const OnlyBottomBouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: StaticData.sidePadding,
                  ),
                  sliver: StreamedStateBuilder<bool>(
                    streamedState: wm.loadingInProgress,
                    builder: (_, loadingInProgress) => loadingInProgress
                        ? const SliverFillRemaining(
                            hasScrollBody: false,
                            child: Center(
                              // TODO(info): везде такой лоадер при загрузке ставить
                              child: AnimatedLoader(),
                            ),
                          )
                        : SliverList(
                            delegate: SliverChildListDelegate(
                              [
                                StreamedStateBuilder<MyLensesPage>(
                                  streamedState: wm.currentPageStreamed,
                                  builder: (_, currentPage) =>
                                      StreamedStateBuilder<LensesPairModel?>(
                                    streamedState: wm.lensesPairModel,
                                    builder: (_, lensesPairModel) =>
                                        lensesPairModel != null
                                            ? currentPage ==
                                                    MyLensesPage.currentLenses
                                                ? wm.currentProduct.value!
                                                            .lifeTime ==
                                                        1
                                                    ? CurrentDailyLensesPage(
                                                        myLensesWM: wm,
                                                      )
                                                    : CurrentMultiLensesPage(
                                                        myLensesWM: wm,
                                                      )
                                                : OldLensesPage(myLensesWM: wm)
                                            : BlueButtonWithText(
                                                text: 'Обновить',
                                                onPressed: () async =>
                                                    wm.loadAllData(),
                                              ),
                                  ),
                                ),
                                const SizedBox(height: 40),
                              ],
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
