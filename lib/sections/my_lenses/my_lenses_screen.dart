import 'package:bausch/sections/my_lenses/my_lenses_wm.dart';
import 'package:bausch/sections/my_lenses/widgets/pages/current_lenses_page.dart';
import 'package:bausch/sections/my_lenses/widgets/pages/lenses_page_switcher.dart';
import 'package:bausch/sections/my_lenses/widgets/pages/old_lenses_page.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class MyLensesScreen extends CoreMwwmWidget<MyLensesWM> {
  MyLensesScreen({Key? key})
      : super(
          key: key,
          widgetModelBuilder: (context) => MyLensesWM(context: context),
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
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(
          horizontal: StaticData.sidePadding,
          vertical: 30,
        ),
        children: [
          // Переключатель (ношу сейчас/были раньше)
          LensesPageSwitcher(myLensesWM: wm),
          const SizedBox(height: 22),
          StreamedStateBuilder<MyLensesPage>(
            streamedState: wm.currentPageStreamed,
            builder: (_, currentPage) =>
                currentPage == MyLensesPage.currentLenses
                    ? CurrentLensesPage(myLensesWM: wm)
                    : OldLensesPage(myLensesWM: wm),
          ),
        ],
      ),
    );
  }
}
