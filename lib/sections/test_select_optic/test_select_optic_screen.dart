import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/sections/sheets/screens/discount_optics/widget_models/discount_optics_screen_wm.dart';
import 'package:bausch/sections/test_select_optic/test_map.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class TestSelectOpticScreen extends CoreMwwmWidget<TestSelectOpticScreenWM> {
  TestSelectOpticScreen({
    Key? key,
    List<OpticCity>? opticCities,
  }) : super(
          key: key,
          widgetModelBuilder: (context) =>
              TestSelectOpticScreenWM(context, opticCities),
        );

  @override
  WidgetState<TestSelectOpticScreen, TestSelectOpticScreenWM>
      createWidgetState() => _TestSelectOpticScreenState();
}

class _TestSelectOpticScreenState
    extends WidgetState<TestSelectOpticScreen, TestSelectOpticScreenWM> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: TestMap(
              widgetModelBuilder: (context) => wm.testMapWM,
            ),
          ),
        ],
      ),
    );
  }
}

class TestSelectOpticScreenWM extends WidgetModel {
  final BuildContext context;
  late final TestMapWM testMapWM;

  final currentCityStreamed = EntityStreamedState<String>();

  List<OpticCity>? opticCities;

  TestSelectOpticScreenWM(this.context, this.opticCities)
      : super(
          const WidgetModelDependencies(),
        ) {
    _initCurrentCity();
    testMapWM = TestMapWM(context);
  }

  void _initCurrentCity() {
    final city = Provider.of<UserWM>(context).userData.value.data?.user.city;
  }
}
