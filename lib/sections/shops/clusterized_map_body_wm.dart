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
  final mapObjectsStreamed = StreamedState<List<MapObject>>(
    <MapObject>[],
  );

  final MapObjectId mapId = const MapObjectId(
    'baush',
  );
  List<MapObject> mapObjectList = [];

  ClusterizedPlacemarkCollection? currentPlacemarks;
  YandexMapController? mapController;
  void Function(ShopModel shop)? onShopClick;

  ClusterizedMapBodyWM({
    required this.initShopList,
  }) : super(
          const WidgetModelDependencies(),
        );

  @override
  void onLoad() {
    updateMapObjects(initShopList);

    // _setCenterOnShops(initShopList);

    super.onLoad();
  }

  void updateMapObjects(List<ShopModel> shopList) {
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
        setCenterOnShops(
          cluster.placemarks.map((e) => e.point).toList(),
        );

        debugPrint('Tapped cluster');
      },
      placemarks: List<Placemark>.generate(
        shopList.length,
        (i) {
          return Placemark(
            onTap: (placemark, point) {
              // mapObjectList.clear();
              // mapObjectsStreamed.accept(mapObjectList);
              mapController?.move(
                cameraPosition: CameraPosition(
                  zoom: 12,
                  target: Point(
                    latitude: placemark.point.latitude - 0.02, // небольшой сдвиг для того, чтобы метка была выше bottomSheet 
                    longitude: placemark.point.longitude,
                  ),
                ),
                animation: const MapAnimation(
                  duration: 1.0,
                ),
              );

              onShopClick?.call(shopList[i]);
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
    );

    // Эта проверка нужна потому, что на карте оставались метки
    // после переключения фильтра
    if (shopList.isEmpty) {
      mapObjectList = [];
    } else {
      mapObjectList = [placemarkCollection];
    }

    mapObjectsStreamed.accept(mapObjectList);
  }

  void setOnShopPressCallback(void Function(ShopModel shop) callback) {
    onShopClick = callback;
  }

  void setCenterOnShops(List<Point> pointList) {
    var north = 0.0;
    var south = double.maxFinite;
    var west = double.maxFinite;
    var east = 0.0;

    for (final point in pointList) {
      if (point.latitude < south) {
        south = point.latitude;
      }
      if (point.latitude > north) {
        north = point.latitude;
      }
      if (point.longitude < west) {
        west = point.longitude;
      }
      if (point.longitude > east) {
        east = point.longitude;
      }
    }

    debugPrint('southWest: $south\t$west');
    debugPrint('northEast: $north\t$east');

    final distance = sqrt(pow(south - north, 2) + pow(west - east, 2));
    debugPrint('distance: $distance');

    // От 0.001 до 1
    final coeff = max(
      min(distance / 10, 1),
      0.001,
    );

    mapController?.setBounds(
      boundingBox: BoundingBox(
        southWest: Point(
          latitude: south - coeff,
          longitude: west - coeff,
        ),
        northEast: Point(
          latitude: north + coeff,
          longitude: east + coeff,
        ),
      ),
    );
  }

  // void _setCenterOnShops(){
  //   mapController.move(cameraPosition: CameraPosition(target: ));
  // }

  // Future<void> updateMapObjects(List<ShopModel> shopList) async {
  //   if (mapObjectList.any((el) => el.mapId == mapId)) {
  //     return;
  //   }

  //   final placemarkCollection = ClusterizedPlacemarkCollection(
  //     mapId: mapId,
  //     radius: 35,
  //     minZoom: 15,
  //     onClusterAdded: (
  //       self,
  //       cluster,
  //     ) async {
  //       return cluster.copyWith(
  //         appearance: cluster.appearance.copyWith(
  //           opacity: 0.75,
  //           icon: PlacemarkIcon.single(
  //             PlacemarkIconStyle(
  //               image: BitmapDescriptor.fromBytes(
  //                 await _buildClusterAppearance(cluster),
  //               ),
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //     onClusterTap: (self, cluster) {
  //       debugPrint('Tapped cluster');
  //     },
  //     placemarks: List<Placemark>.generate(
  //       shopList.length,
  //       (i) {
  //         return Placemark(
  //           onTap: (placemark, point) {
  //             mapObjectList.clear();
  //           },
  //           opacity: 1,
  //           mapId: MapObjectId('placemark_${shopList[i].coords}'),
  //           point: shopList[i].coords!,
  //           icon: PlacemarkIcon.single(
  //             PlacemarkIconStyle(
  //               scale: 1,
  //               image: BitmapDescriptor.fromAssetImage(
  //                 'assets/icons/map-marker.png',
  //               ),
  //             ),
  //           ),
  //         );
  //       },
  //     ),
  //     // onTap: (self, point) => debugPrint('Tapped me at $point'),
  //   );

  //   // Эта проверка нужна потому, что на карте оставались метки
  //   if (shopList.isEmpty) {
  //     mapObjectList = [];
  //   } else {
  //     mapObjectList = [placemarkCollection];
  //   }
  // }

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

  Point _calcMiddlePoint(List<Point> pointList) {
    var middlePoint = const Point(latitude: 0, longitude: 0);

    for (final point in pointList) {
      middlePoint = Point(
        latitude: middlePoint.latitude + point.latitude,
        longitude: middlePoint.longitude + point.longitude,
      );
    }

    return Point(
      latitude: middlePoint.latitude / pointList.length,
      longitude: middlePoint.longitude / pointList.length,
    );
  }
}
