import 'package:bausch/models/add_points/add_points_model.dart';
import 'package:bausch/sections/my_lenses/my_lenses_wm.dart';
import 'package:bausch/sections/sheets/screens/add_points/widget_models/add_points_wm.dart';
import 'package:bausch/sections/sheets/screens/add_points/widgets/add_item.dart';
import 'package:bausch/sections/sheets/screens/add_points/widgets/code_section.dart';
import 'package:bausch/sections/sheets/widgets/custom_sheet_scaffold.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/error_page.dart';
import 'package:bausch/widgets/loader/animated_loader.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

//* Add_points
//* list
class AddPointsScreen extends CoreMwwmWidget<AddPointsWM> {
  final ScrollController controller;
  // TODO(all): не знаю как лучше пробросить эти линзы, везде передаю
  final MyLensesWM? myLensesWM;
  AddPointsScreen({
    required this.controller,
    required this.myLensesWM,
    Key? key,
  }) : super(
          key: key,
          widgetModelBuilder: (context) {
            return AddPointsWM(context: context);
          },
        );

  @override
  WidgetState<CoreMwwmWidget<AddPointsWM>, AddPointsWM> createWidgetState() =>
      _AddPointsScreenState();
}

class _AddPointsScreenState extends WidgetState<AddPointsScreen, AddPointsWM> {
  @override
  Widget build(BuildContext context) {
    return CustomSheetScaffold(
      controller: widget.controller,
      resizeToAvoidBottomInset: false,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.only(
            right: StaticData.sidePadding,
            left: StaticData.sidePadding,
            bottom: 20,
            top: 66,
          ),
          sliver: SliverToBoxAdapter(
            child: CodeSection(myLensesWM: widget.myLensesWM),
          ),
        ),
        EntityStateBuilder<List<AddPointsModel>>(
          streamedState: wm.addPointsList,
          loadingChild: const SliverToBoxAdapter(),
          errorChild: const SliverToBoxAdapter(),
          builder: (_, items) {
            if (items.isNotEmpty) {
              return SliverAppBar(
                pinned: true,
                shadowColor: Colors.transparent,
                backgroundColor: AppTheme.mystic,
                collapsedHeight: 90,
                elevation: 0,
                leading: const SizedBox(),
                flexibleSpace: Padding(
                  padding: const EdgeInsets.symmetric(
                    // vertical: 20,
                    horizontal: StaticData.sidePadding,
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/add-points.png',
                        height: 66,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      const Text(
                        'Добавить ещё',
                        style: AppStyles.h1,
                      ),
                    ],
                  ),
                ),
              );
            }

            return const SliverToBoxAdapter();
          },
        ),
        EntityStateBuilder<List<AddPointsModel>>(
          streamedState: wm.addPointsList,
          loadingChild: const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: AnimatedLoader(),
            ),
          ),
          errorChild: SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: SimpleErrorWidget(
                title: 'Не удалось загрузить',
                buttonText: 'Обновить',
                buttonCallback: wm.loadInfoAction,
              ),
            ),
          ),
          builder: (_, items) {
            return SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: StaticData.sidePadding,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    ...List.generate(
                      items.length,
                      (index) {
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: index == items.length - 1
                                ? StaticData.sidePadding
                                : 4,
                          ),
                          child: AddItem(
                            model: items[index],
                            wm: wm,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
