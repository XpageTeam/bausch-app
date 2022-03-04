import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/models/city/dadata_cities_downloader.dart';
import 'package:bausch/models/dadata/dadata_response_data_model.dart';
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
  final List<OpticShop> initOpticShops;
  final Future<void> Function(DadataResponseDataModel) onCityDefinitionCallback;

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
  final updateMapObjectsWhenComplete = StreamedAction<List<OpticShop>>();

  final isModalBottomSheetOpen = StreamedState<bool>(false);

  final zoomInAction = VoidAction();
  final zoomOutAction = VoidAction();
  final moveToUserPosition = VoidAction();

  YandexMapController? mapController;

  void Function(OpticShop shop)? onPlacemarkPressed;
  void Function(CustomException exception)? onGetUserPositionError;

  Random rng = Random();

  MapBodyWM({
    required this.initOpticShops,
    required this.onCityDefinitionCallback,
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

    updateMapObjectsWhenComplete.bind((shopList) {
      _updateClusterMapObject(shopList!);
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
          final rnd = rng.nextInt(200);
          final placemarkId = 'p_${i}_${rnd}_${shopList[i].coords}';

          return Placemark(
            onTap: (placemark, point) async {
              _updateClusterMapObject(shopList, i);
              unawaited(_moveTo(placemark.point));
              onPlacemarkPressed?.call(shopList[i]);
            },
            opacity: 1,
            mapId: MapObjectId(placemarkId),
            // MapObjectId('placemark_${shopList[i].coords}'),
            point: shopList[i].coords,
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

    await Future<void>.delayed(
      const Duration(
        milliseconds: 200,
      ),
    );

    BoundingBox? bounds;

    if (list is List<Point>) {
      bounds = _getBounds(list as List<Point>);
    } else if (list is List<Placemark>) {
      bounds = _getBounds(
        (list as List<Placemark>).map((e) => e.point).toList(),
      );
    } else if (list is List<ShopModel>) {
      bounds = _getBounds(
        (list as List<ShopModel>).map((e) => e.coords!).toList(),
      );
    } else if (list is List<OpticShop>) {
      bounds = _getBounds(
        (list as List<OpticShop>).map((e) => e.coords).toList(),
      );
    } else {
      return;
    }

    await Future.delayed(
      const Duration(
        milliseconds: 200,
      ),
      () async => mapController?.moveCamera(
        CameraUpdate.newBounds(bounds!),
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

    unawaited(mapObjectsStreamed.accept(mapObjectsStreamed.value));
    unawaited(_moveTo(position));
  }

  Future<void> _moveTo(Point point) async {
    await mapController?.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          zoom: 16,
          target: Point(
            latitude: point.latitude -
                0.001, // небольшой сдвиг для того, чтобы метка была выше bottomSheet
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

    await _trySetCityByUserPosition(position);

    return Point(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }

  Future<void> _trySetCityByUserPosition(Position position) async {
    // Список городов (по-идее не больше одного города здесь должно быть)
    final possibleCities =
        await CitiesDownloader().loadDadataCityByUserPosition(
      position,
    );

    if (possibleCities.isEmpty || possibleCities.first.data.city == null) {
      return;
    }
    await onCityDefinitionCallback(possibleCities.first.data);
  }

  BoundingBox _getBounds(List<Point> points) {
    final lngs = points.map<double>((m) => m.longitude).toList();
    final lats = points.map<double>((m) => m.latitude).toList();

    final highestLat = lats.reduce(max);
    final highestLng = lngs.reduce(max);
    final lowestLat = lats.reduce(min);
    final lowestLng = lngs.reduce(min);

    final offset = _calcBoundsOffset(
      highestLat,
      highestLng,
      lowestLat,
      lowestLng,
    );

    return BoundingBox(
      northEast:
          Point(latitude: highestLat + offset, longitude: highestLng + offset),
      southWest:
          Point(latitude: lowestLat - offset, longitude: lowestLng - offset),
    );
  }

  double _calcBoundsOffset(
    double highestLat,
    double highestLng,
    double lowestLat,
    double lowestLng,
  ) {
    final distance = sqrt(
      pow(lowestLat - highestLat, 2) + pow(lowestLng - highestLng, 2),
    );

    // От 0.001 до 1
    return max(
      min(distance / 10, 1),
      0.001,
    );
  }

  Future<Uint8List> _buildClusterAppearance(Cluster cluster) async {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);

    const size = Size(200, 200);

    final fillPaint = Paint()
      ..color = AppTheme.turquoiseBlue
      ..style = PaintingStyle.fill;

    final radius = min(max(cluster.size * 6.0, 30), 50).toDouble();

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
