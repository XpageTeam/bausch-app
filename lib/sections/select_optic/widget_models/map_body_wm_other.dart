import 'dart:math';
import 'dart:typed_data';

import 'package:bausch/sections/sheets/screens/discount_optics/widget_models/discount_optics_screen_wm.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:surf_mwwm/surf_mwwm.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class MapBodyOtherWM extends WidgetModel {
  final controllerWm = MapControllerWM();

  final isModalBottomSheetOpen = StreamedState<bool>(false);
  final updateCluster = VoidAction();
  final mapObjectsStreamed = StreamedState<List<MapObject>>(
    <MapObject>[],
  );

  final clusterId = const MapObjectId('cluster');
  final List<MapObject> mapObjects = [];
  YandexMapController? mapController;

  MapBodyOtherWM()
      : super(
          const WidgetModelDependencies(),
        ) {
    _addCluster();
  }

  @override
  void onBind() {
    updateCluster.bind((p0) => _updateCluster());
    super.onBind();
  }

  void initMapController(YandexMapController newMapController) {
    mapController = newMapController;
    controllerWm.mapController = newMapController;
  }

  void updateMapObects(List<OpticShop> opticShops) {
    mapObjectsStreamed.value.removeWhere(
      (obj) => obj.mapId == clusterId,
    );

    final placemarkCollection = ClusterizedPlacemarkCollection(
      mapId: clusterId,
      radius: 15,
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
      // onClusterTap: (self, cluster) => _setCenterOn(cluster.placemarks),
      placemarks: List<Placemark>.generate(
        opticShops.length,
        (i) {
          return Placemark(
            // onTap: (placemark, point) async {
            //   unawaited(_moveTo(placemark.point));
            //   _updateClusterMapObject(shopList, i);
            //   onPlacemarkPressed?.call(shopList[i]);
            // },
            opacity: 1,
            mapId: MapObjectId('placemark_${opticShops[i].coords}'),
            point: opticShops[i].coords,
            icon: PlacemarkIcon.single(
              PlacemarkIconStyle(
                scale: 1,
                image: BitmapDescriptor.fromAssetImage(
                  'assets/icons/map-marker.png',
                ),
              ),
            ),
          );
        },
      ),
    );

    //mapObjectsStreamed.value.add(placemarkCollection);

    mapObjectsStreamed.accept([placemarkCollection]);
  }

  void _addCluster() {
    if (mapObjects.any((el) => el.mapId == clusterId)) {
      return;
    }

    final clusterizedPlacemarkCollection = ClusterizedPlacemarkCollection(
      mapId: clusterId,
      radius: 30,
      minZoom: 15,
      onClusterAdded: (self, cluster) async {
        return cluster.copyWith(
          appearance: cluster.appearance.copyWith(
            opacity: 1,
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
      // onClusterTap: (ClusterizedPlacemarkCollection self, Cluster cluster) {
      //   print('Tapped cluster');
      // },
      placemarks: [
        Placemark(
          mapId: const MapObjectId('placemark_1'),
          point: const Point(latitude: 55.756, longitude: 37.618),
          opacity: 1,
          consumeTapEvents: true,
          // onTap: (Placemark self, Point point) =>
          //     print('Tapped placemark at $point'),
          icon: PlacemarkIcon.single(
            PlacemarkIconStyle(
              image: BitmapDescriptor.fromAssetImage(
                'assets/icons/map-marker.png',
              ),
            ),
          ),
        ),
        Placemark(
          mapId: const MapObjectId(
            'placemark_2',
          ),
          point: const Point(latitude: 59.956, longitude: 30.313),
          opacity: 1,
          icon: PlacemarkIcon.single(
            PlacemarkIconStyle(
              image: BitmapDescriptor.fromAssetImage(
                'assets/icons/map-marker.png',
              ),
            ),
          ),
        ),
        Placemark(
          mapId: const MapObjectId('placemark_3'),
          point: const Point(latitude: 39.956, longitude: 30.313),
          opacity: 1,
          icon: PlacemarkIcon.single(
            PlacemarkIconStyle(
              image: BitmapDescriptor.fromAssetImage(
                'assets/icons/map-marker.png',
              ),
            ),
          ),
        ),
      ],

      // onTap: (ClusterizedPlacemarkCollection self, Point point) =>
      //     print('Tapped me at $point'),
    );

    mapObjects.add(clusterizedPlacemarkCollection);

    mapObjectsStreamed.accept(mapObjects);
  }

  void _updateCluster() {
    if (!mapObjects.any((el) => el.mapId == clusterId)) {
      return;
    }

    final clusterizedPlacemarkCollection =
        mapObjects.firstWhere((el) => el.mapId == clusterId)
            as ClusterizedPlacemarkCollection;

    mapObjects[mapObjects.indexOf(clusterizedPlacemarkCollection)] =
        clusterizedPlacemarkCollection.copyWith(
      onClusterAdded: (self, cluster) async {
        return cluster.copyWith(
          appearance: cluster.appearance.copyWith(
            opacity: 1,
            icon: PlacemarkIcon.single(
              PlacemarkIconStyle(
                image: BitmapDescriptor.fromBytes(
                  await _buildClusterAppearance(cluster, Colors.amber),
                ),
              ),
            ),
          ),
        );
      },
      placemarks: [
        Placemark(
          mapId: const MapObjectId('placemark_2'),
          point: const Point(latitude: 59.956, longitude: 30.313),
          icon: PlacemarkIcon.single(
            PlacemarkIconStyle(
              image: BitmapDescriptor.fromAssetImage(
                'assets/icons/map-marker.png',
              ),
            ),
          ),
        ),
        Placemark(
          mapId: const MapObjectId('placemark_3'),
          point: const Point(latitude: 39.956, longitude: 31.313),
          icon: PlacemarkIcon.single(
            PlacemarkIconStyle(
              image: BitmapDescriptor.fromAssetImage(
                'assets/icons/map-marker.png',
              ),
            ),
          ),
        ),
        Placemark(
          mapId: const MapObjectId('placemark_4'),
          point: const Point(latitude: 59.945933, longitude: 30.320045),
          icon: PlacemarkIcon.single(
            PlacemarkIconStyle(
              image: BitmapDescriptor.fromAssetImage(
                'assets/icons/map-marker.png',
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<Uint8List> _buildClusterAppearance(
    Cluster cluster, [
    Color color = AppTheme.turquoiseBlue,
  ]) async {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);

    const size = Size(200, 200);

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final radius = min(max(cluster.size * 6.0, 30), 70).toDouble();

    final textPainter = TextPainter(
      text: TextSpan(
        text: cluster.size.toString(),
        style: AppStyles.h2Bold.copyWith(
          fontSize: 40,
          color: Colors.white,
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

class MapControllerWM extends WidgetModel {
  final zoomInAction = VoidAction();
  final zoomOutAction = VoidAction();
  final moveToUserPosition = VoidAction();

  YandexMapController? mapController;

  MapControllerWM()
      : super(
          const WidgetModelDependencies(),
        ) {
    onBind();
  }

  @override
  void onBind() {
    zoomInAction.bind((_) {
      mapController?.moveCamera(
        CameraUpdate.zoomIn(),
        animation: const MapAnimation(
          duration: 0.5,
        ),
      );
    });

    zoomOutAction.bind((_) {
      mapController?.moveCamera(
        CameraUpdate.zoomOut(),
        animation: const MapAnimation(
          duration: 0.5,
        ),
      );
    });

    moveToUserPosition.bind(
      (value) {
        _updateUserPosition();
      },
    );
    super.onBind();
  }

  void _updateUserPosition() {}
}
