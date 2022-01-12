import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class TestMap extends CoreMwwmWidget<TestMapWM> {
  const TestMap({
    required TestMapWM Function(BuildContext context) widgetModelBuilder,
    Key? key,
  }) : super(
          key: key,
          widgetModelBuilder: widgetModelBuilder,
        );

  @override
  WidgetState<TestMap, TestMapWM> createWidgetState() => _TestMapState();
}

class _TestMapState extends WidgetState<TestMap, TestMapWM> {
  @override
  void didUpdateWidget(covariant TestMap oldWidget) {
    wm.updateMapObjectsAction();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return StreamedStateBuilder<List<MapObject>>(
      streamedState: wm.mapObjectsStreamed,
      builder: (context, mapObjects) {
        return YandexMap(
          liteModeEnabled: true,
          mode2DEnabled: true,
          mapObjects: mapObjects,
          onMapCreated: (yandexMapController) {
            wm.mapController = yandexMapController;
          },
        );
      },
    );
  }
}

class TestMapWM extends WidgetModel {
  final BuildContext context;

  final mapObjectsStreamed = StreamedState<List<MapObject>>([]);
  final updateMapObjectsAction = VoidAction();

  YandexMapController? mapController;

  TestMapWM(this.context)
      : super(
          const WidgetModelDependencies(),
        ) {
    _updateMapObjects();

    bind();
  }

  void bind() {
    updateMapObjectsAction.bind((p0) => _updateMapObjects());
  }

  void _updateMapObjects() {}
}
