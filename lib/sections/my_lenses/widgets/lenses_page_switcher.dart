import 'package:bausch/sections/my_lenses/my_lenses_wm.dart';
import 'package:bausch/sections/my_lenses/widgets/lenses_toggle_button.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class LensesPageSwitcher extends CoreMwwmWidget<LensesPageSwitcherWM> {
  LensesPageSwitcher({
    required void Function(MyLensesPage) callback,
    MyLensesPage initialType = MyLensesPage.currentLenses,
    Key? key,
  }) : super(
          key: key,
          widgetModelBuilder: (_) => LensesPageSwitcherWM(
            callback: callback,
            initialType: initialType,
          ),
        );

  @override
  WidgetState<CoreMwwmWidget<LensesPageSwitcherWM>, LensesPageSwitcherWM>
      createWidgetState() => _LensesPageSwitcherState();
}

class _LensesPageSwitcherState
    extends WidgetState<LensesPageSwitcher, LensesPageSwitcherWM> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: MyLensesPage.values
          .map(
            (type) => StreamedStateBuilder<MyLensesPage>(
              streamedState: wm.currentTypeStreamed,
              builder: (_, currentType) => Expanded(
                child: LensesToggleButton(
                  type: type,
                  color: currentType == type
                      ? AppTheme.turquoiseBlue
                      : Colors.white,
                  onPressed: wm.buttonAction,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class LensesPageSwitcherWM extends WidgetModel {
  final MyLensesPage initialType;
  final void Function(MyLensesPage) callback;

  late final currentTypeStreamed = StreamedState<MyLensesPage>(initialType);
  final buttonAction = StreamedAction<MyLensesPage>();

  LensesPageSwitcherWM({required this.initialType, required this.callback})
      : super(const WidgetModelDependencies());

  @override
  void onBind() {
    buttonAction.bind((type) {
      currentTypeStreamed.accept(type!);
      callback(type);
    });
    super.onBind();
  }
}
