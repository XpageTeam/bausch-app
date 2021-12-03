import 'dart:math';
import 'dart:typed_data';

import 'package:bausch/models/shop/shop_model.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:surf_mwwm/surf_mwwm.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class ClusterizedMapBodyWM extends WidgetModel {
  final List<ShopModel> initShopList;
  final MapObjectId mapId = const MapObjectId(
    'baush',
  );
  List<MapObject> mapObjectList = [];

  ClusterizedPlacemarkCollection? currentPlacemarks;
  YandexMapController? mapController;

  ClusterizedMapBodyWM({
    required this.initShopList,
  }) : super(
          const WidgetModelDependencies(),
        );

  @override
  void onLoad() {
    updateMapObjects(initShopList);
    super.onLoad();
  }

  Future<void> updateMapObjects(List<ShopModel> shopList) async {
    if (mapObjectList.any((el) => el.mapId == mapId)) {
      return;
    }

    final placemarkCollection = ClusterizedPlacemarkCollection(
      mapId: mapId,
      radius: 35,
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
            onTap: (placemark, point) {
              mapObjectList.clear();
            },
            opacity: 1,
            mapId: MapObjectId('placemark_${shopList[i].coords}'),
            point: shopList[i].coords!,
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
      // onTap: (self, point) => debugPrint('Tapped me at $point'),
    );

    // Эта проверка нужна потому, что на карте оставались метки
    if (shopList.isEmpty) {
      mapObjectList = [];
    } else {
      mapObjectList = [placemarkCollection];
    }
  }

  // void setCenterOnShops() {
  //   if (currentPlacemarks != null && mapController != null) {
  //     //* Иначе - вычисляю среднюю координату и центрируюсь на ней
  //     final middlePoint = _calcMiddlePoint(
  //       currentPlacemarks!.placemarks,
  //     );
  //     var min = 100.0;
  //     var max = 0.0;
  //     var northEast = Point(latitude: 0, longitude: 0);
  //     var southWest = Point(latitude: 100.0, longitude: 0);

  //     for (var p in currentPlacemarks!.placemarks) {
  //       if (p.point.latitude > northEast.latitude) {
  //         northEast = p.point;
  //       }
  //       if (p.point.latitude < southWest.latitude) {
  //         southWest = p.point;
  //       }
  //     }

  //     // await mapController!.move(
  //     //   cameraPosition: CameraPosition(target: middlePoint),
  //     // );

  //     mapController!.setBounds(
  //       boundingBox: BoundingBox(northEast: northEast, southWest: southWest),
  //     );
  //   }
  // }

  void setMapController(YandexMapController controller) {
    mapController = controller;
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

  Point _calcMiddlePoint(List<Placemark> placemarkList) {
    var middlePoint = const Point(latitude: 0, longitude: 0);
    for (final placemark in placemarkList) {
      middlePoint = Point(
        latitude: middlePoint.latitude + placemark.point.latitude,
        longitude: middlePoint.longitude + placemark.point.longitude,
      );
    }

    return Point(
      latitude: middlePoint.latitude / placemarkList.length,
      longitude: middlePoint.longitude / placemarkList.length,
    );
  }
}
