import 'dart:math';
import 'dart:typed_data';

import 'package:bausch/models/shop/shop_model.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:surf_mwwm/surf_mwwm.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class ClusterizedMapButtonsWM extends WidgetModel {
  final void Function(List<MapObject> mapObjects) callback;
  final List<ShopModel> shopList;

  final YandexMapController mapController;
  final List<MapObject> mapObjects = [];

  final MapObjectId mapId = const MapObjectId(
    'baush',
  );

  final zoomInAction = VoidAction();
  final zoomOutAction = VoidAction();
  final userPositionAction = VoidAction();

  final addPlacemarksAction = VoidAction();
  final removePlacemarksAction = VoidAction();

  ClusterizedMapButtonsWM({
    required this.mapController,
    required this.callback,
    required this.shopList,
  }) : super(
          const WidgetModelDependencies(),
        );

  @override
  Future<void> onLoad() async {
    mapObjects.clear();
    
    final shopsWithCoords =
        shopList.where((element) => element.coords != null).toList();
    await _initMapObjects(shopsWithCoords);
    callback(mapObjects);

    super.onLoad();
  }

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

  Future<void> _initMapObjects(List<ShopModel> shopList) async {
    if (mapObjects.any((e) => e.mapId == mapId)) {
      return;
    }
    final clusterizedPlacemarkCollection = ClusterizedPlacemarkCollection(
      mapId: mapId,
      radius: 30,
      minZoom: 15,
      onClusterAdded: (
        self,
        cluster,
      ) async {
        return cluster.copyWith(
          appearance: cluster.appearance.copyWith(
            opacity: 0.75,
            icon: PlacemarkIcon.single(
              PlacemarkIconStyle(
                image: BitmapDescriptor.fromBytes(
                  await _buildClusterAppearance(cluster),
                ),
              ),
            ),
          ),
        );
      },
      onClusterTap: (self, cluster) {
        debugPrint('Tapped cluster');
      },
      placemarks: List<Placemark>.generate(
        shopList.length,
        (i) {
          return Placemark(
            opacity: 1,
            mapId: MapObjectId('placemark_$i'),
            point: shopList[i].coords!,
            icon: PlacemarkIcon.single(
              PlacemarkIconStyle(
                image: BitmapDescriptor.fromAssetImage(
                  'assets/icons/map-marker.png',
                ),
              ),
            ),
          );
        },
      ),
      onTap: (self, point) => debugPrint('Tapped me at $point'),
    );

    mapObjects.add(clusterizedPlacemarkCollection);
  }

  Future<Uint8List> _buildClusterAppearance(Cluster cluster) async {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);

    const size = Size(200, 200);

    final fillPaint = Paint()
      ..color = AppTheme.turquoiseBlue
      ..style = PaintingStyle.fill;

    final radius = min(max(cluster.size * 6.0, 30), 70).toDouble();

    final textPainter = TextPainter(
      text: TextSpan(
        text: cluster.size.toString(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 50,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: size.width);

    final textOffset = Offset(
      (size.width - textPainter.width) / 2,
      (size.height - textPainter.height) / 2,
    );
    final circleOffset = Offset(size.height / 2, size.width / 2);

    canvas.drawCircle(circleOffset, radius, fillPaint);
    textPainter.paint(canvas, textOffset);

    final image = await recorder
        .endRecording()
        .toImage(size.width.toInt(), size.height.toInt());
    final pngBytes = await image.toByteData(format: ImageByteFormat.png);

    return pngBytes!.buffer.asUint8List();
  }
}
