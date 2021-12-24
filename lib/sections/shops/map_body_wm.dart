import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/models/discount_optic/discount_optic.dart';
import 'package:bausch/models/shop/shop_model.dart';
import 'package:bausch/sections/sheets/screens/discount_optics/widget_models/discount_optics_screen_wm.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:geolocator/geolocator.dart';
import 'package:surf_mwwm/surf_mwwm.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class MapBodyWM extends WidgetModel {
  final List<ShopModel> initShopList;
  final List<OpticShop> initOpticShops;

  final MapObjectId clusterMapId = const MapObjectId(
    'cluster',
  );

  final MapObjectId userMapId = const MapObjectId(
    'user',
  );

  final mapObjectsStreamed = StreamedState<List<MapObject>>(
    <MapObject>[],
  );

  final setCenterAction = StreamedAction<List<OpticShop>>();
  final updateMapObjects = StreamedAction<List<OpticShop>>();

  final isModalBottomSheetOpen = StreamedState<bool>(false);

  final zoomInAction = VoidAction();
  final zoomOutAction = VoidAction();
  final moveToUserPosition = VoidAction();

  YandexMapController? mapController;

  void Function(OpticShop shop)? onPlacemarkPressed;
  void Function(CustomException exception)? onGetUserPositionError;

  MapBodyWM({
    required this.initShopList,
    required this.initOpticShops,
  }) : super(
          const WidgetModelDependencies(),
        );

  @override
  void onLoad() {
    // Пришлось обернуть в future, потому что иногда метки не отрисовывались
    Future.delayed(
      Duration.zero,
      () => updateMapObjects(initOpticShops),
    );
    super.onLoad();
  }

  @override
  void onBind() {
    updateMapObjects.bind((shopList) {
      _updateClusterMapObject(shopList!);
      if (mapController != null) {
        _setCenterOn(shopList);
      }
    });

    moveToUserPosition.bind(
      (value) {
        _updateUserPosition();
      },
    );

    setCenterAction.bind(
      (opticShops) => _setCenterOn(opticShops!),
    );

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

    super.onBind();
  }

  void _updateClusterMapObject(
    List<OpticShop> shopList, [
    int? indexOfPressedShop,
  ]) {
    mapObjectsStreamed.value.removeWhere(
      (obj) => obj.mapId == clusterMapId,
    );

    final placemarkCollection = ClusterizedPlacemarkCollection(
      mapId: clusterMapId,
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
      onClusterTap: (self, cluster) => _setCenterOn(cluster.placemarks),
      placemarks: List<Placemark>.generate(
        shopList.length,
        (i) {
          return Placemark(
            onTap: (placemark, point) async {
              unawaited(_moveTo(placemark.point));
              _updateClusterMapObject(shopList, i);
              onPlacemarkPressed?.call(shopList[i]);
            },
            opacity: 1,
            mapId: MapObjectId('placemark_${shopList[i].coords}'),
            point: shopList[i].coords!,
            icon: PlacemarkIcon.single(
              PlacemarkIconStyle(
                scale: indexOfPressedShop != null
                    ? indexOfPressedShop == i
                        ? 2
                        : 1
                    : 1,
                image: BitmapDescriptor.fromAssetImage(
                  'assets/icons/map-marker.png',
                ),
              ),
            ),
          );
        },
      ),
    );

    mapObjectsStreamed.value.add(placemarkCollection);

    mapObjectsStreamed.accept(mapObjectsStreamed.value);
  }

  Future<void> _setCenterOn<T>(List<T> list) async {
    // TODO(Nikolay): Возможно надо будет центрироваться на позиции пользователя, если список пуст.
    if (list.isEmpty) return;

    ExtremePoints? extremePoints;

    if (list is List<Point>) {
      extremePoints = _getExtremePoints(list as List<Point>);
    } else if (list is List<Placemark>) {
      extremePoints = _getExtremePoints(
        (list as List<Placemark>).map((e) => e.point).toList(),
      );
    } else if (list is List<ShopModel>) {
      extremePoints = _getExtremePoints(
        (list as List<ShopModel>).map((e) => e.coords!).toList(),
      );
    } else {
      return;
    }

    await Future.delayed(
      const Duration(
        milliseconds: 500,
      ),
      () async => mapController?.moveCamera(
        CameraUpdate.newBounds(
          BoundingBox(
            southWest: extremePoints!.southWest,
            northEast: extremePoints.northEast,
          ),
        ),
      ),
    );
  }

  Future<void> _updateUserPosition() async {
    mapObjectsStreamed.value
        .removeWhere((element) => element.mapId == userMapId);

    final position = await _getUserPosition();

    mapObjectsStreamed.value.add(
      Placemark(
        mapId: userMapId,
        point: position,
        opacity: 1,
        icon: PlacemarkIcon.single(
          PlacemarkIconStyle(
            image: BitmapDescriptor.fromAssetImage(
              'assets/icons/user-marker.png',
            ),
          ),
        ),
      ),
    );

    unawaited(_moveTo(position));

    unawaited(mapObjectsStreamed.accept(mapObjectsStreamed.value));
  }

  Future<void> _moveTo(Point point) async {
    await mapController?.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          zoom: 16,
          target: Point(
            latitude: point.latitude -
                0.0015, // небольшой сдвиг для того, чтобы метка была выше bottomSheet
            longitude: point.longitude,
          ),
        ),
      ),
      animation: const MapAnimation(
        duration: 1.0,
      ),
    );
  }

  Future<Point> _getUserPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // onError
      onGetUserPositionError?.call(
        const CustomException(
          title: 'Невозможно определить местоположение',
        ),
      );
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // onError
        onGetUserPositionError?.call(
          const CustomException(
            title: 'Невозможно определить местоположение',
          ),
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // onError
      onGetUserPositionError?.call(
        const CustomException(
          title: 'Невозможно определить местоположение',
        ),
      );
    }

    final position = await Geolocator.getCurrentPosition();

    return Point(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }

  ExtremePoints _getExtremePoints(List<Point> pointList) {
    var north = 0.0;
    var south = double.maxFinite;
    var west = double.maxFinite;
    var east = 0.0;

    for (final point in pointList) {
      if (point.latitude > north) north = point.latitude;
      if (point.latitude < south) south = point.latitude;
      if (point.longitude < west) west = point.longitude;
      if (point.longitude > east) east = point.longitude;
    }

    debugPrint('north: $north');
    debugPrint('south: $south');
    debugPrint('west: $west');
    debugPrint('east: $east');

    final distance = sqrt(
      pow(south - north, 2) + pow(west - east, 2),
    );

    // От 0.001 до 1
    final coeff = max(
      min(distance / 10, 1),
      0.001,
    );

    return ExtremePoints(
      southWest: Point(
        latitude: south - coeff,
        longitude: west - coeff,
      ),
      northEast: Point(
        latitude: north + coeff,
        longitude: east + coeff,
      ),
    );
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

class ExtremePoints {
  final Point southWest;
  final Point northEast;

  ExtremePoints({
    required this.southWest,
    required this.northEast,
  });
}
