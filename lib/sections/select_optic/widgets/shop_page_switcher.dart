import 'package:bausch/sections/select_optic/widget_models/select_optics_screen_wm.dart';
import 'package:bausch/sections/select_optic/widgets/optics_toggle_button.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class ShopPageSwitcher extends CoreMwwmWidget<ShopPageSwitcherWM> {
  final SelectOpticPage initialType;
  ShopPageSwitcher({
    required void Function(SelectOpticPage) callback,
    this.initialType = SelectOpticPage.map,
    Key? key,
  }) : super(
          key: key,
          widgetModelBuilder: (_) => ShopPageSwitcherWM(
            callback: callback,
            initialType: initialType,
          ),
        );

  @override
  WidgetState<CoreMwwmWidget<ShopPageSwitcherWM>, ShopPageSwitcherWM>
      createWidgetState() => _ShopPageSwitcherState();
}

class _ShopPageSwitcherState
    extends WidgetState<ShopPageSwitcher, ShopPageSwitcherWM> {
  @override
  void didUpdateWidget(covariant ShopPageSwitcher oldWidget) {
    if (oldWidget.initialType != widget.initialType) {
      wm.buttonAction(widget.initialType);
      super.didUpdateWidget(oldWidget);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamedStateBuilder<SelectOpticPage>(
      streamedState: wm.currentTypeStreamed,
      builder: (_, currentType) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: SelectOpticPage.values
              .map(
                (type) => Expanded(
                  child: OpticsToggleButton(
                    type: type,
                    color: currentType == type
                        ? AppTheme.turquoiseBlue
                        : Colors.white,
                    onPressed: wm.buttonAction,
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class ShopPageSwitcherWM extends WidgetModel {
  final SelectOpticPage initialType;
  final void Function(SelectOpticPage) callback;

  late final currentTypeStreamed = StreamedState<SelectOpticPage>(initialType);
  final buttonAction = StreamedAction<SelectOpticPage>();

  ShopPageSwitcherWM({
    required this.initialType,
    required this.callback,
  }) : super(
          const WidgetModelDependencies(),
        );

  @override
  void onBind() {
    buttonAction.bind((type) {
      currentTypeStreamed.accept(type!);
      callback(type);
    });
    super.onBind();
  }
}
