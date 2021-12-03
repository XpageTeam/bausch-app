
import 'package:surf_mwwm/surf_mwwm.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class ClusterizedMapButtonsWM extends WidgetModel {
  final YandexMapController mapController;

  final zoomInAction = VoidAction();
  final zoomOutAction = VoidAction();
  final userPositionAction = VoidAction();

  ClusterizedMapButtonsWM({
    required this.mapController,
  }) : super(
          const WidgetModelDependencies(),
        );

  @override
  void onBind() {
    subscribe(zoomInAction.stream, (value) {
      // zoomIn
      mapController.zoomIn();
    });
    subscribe(zoomOutAction.stream, (value) {
      // zoomOut
      mapController.zoomOut();
    });
    subscribe(userPositionAction.stream, (value) async {
      // userPosition
      // await mapController.toggleUserLayer(visible: true);
    });

    super.onBind();
  }
}
