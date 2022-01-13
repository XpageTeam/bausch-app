import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/models/shop/shop_model.dart';
import 'package:bausch/sections/sheets/screens/discount_optics/widget_models/discount_optics_screen_wm.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/123/default_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:geolocator/geolocator.dart';
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
  Widget build(BuildContext context) {
    return ClipRRect(
      clipBehavior: Clip.hardEdge,
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(5),
      ),
      child: StreamedStateBuilder<List<MapObject>>(
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
      ),
    );
  }
}

class TestMapWM extends WidgetModel {
  final BuildContext context;

  final mapObjectsStreamed = StreamedState<List<MapObject>>([]);
  final updateMapObjectsAction = StreamedAction<List<OpticShop>>();
  final setCenterAction = StreamedAction<List<OpticShop>>();

  final clusterMapId = const MapObjectId('cluster');
  final userMapId = const MapObjectId('user');

  YandexMapController? mapController;

  TestMapWM(
    this.context,
    List<OpticShop> initialShops,
  ) : super(
          const WidgetModelDependencies(),
        ) {
    _updateMapObjects(initialShops);

    bind();
  }

  void bind() {
    updateMapObjectsAction.bind((shops) => _updateMapObjects(shops!));

    setCenterAction.bind(
      (opticShops) => _setCenterOn(opticShops!),
    );
  }

  void _updateMapObjects(List<OpticShop> shops) {
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
        debugPrint('cluster: ${cluster.size}');
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
        shops.length,
        (i) {
          return Placemark(
            onTap: (placemark, point) async {
              unawaited(_moveTo(placemark.point));
              // _updateClusterMapObject(shopList, i);
              // onPlacemarkPressed?.call(shopList[i]);
            },
            opacity: 1,
            mapId: MapObjectId('placemark_${shops[i].coords} $i'),
            point: shops[i].coords,
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

    mapObjectsStreamed.value.add(placemarkCollection);
    mapObjectsStreamed.accept(mapObjectsStreamed.value);
  }

  Future<void> _setCenterOn<T>(List<T> list) async {
    // TODO(Nikolay): Возможно надо будет центрироваться на позиции пользователя, если список пуст.
    if (list.isEmpty) return;

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
        milliseconds: 500,
      ),
      () async => mapController?.moveCamera(
        CameraUpdate.newBounds(bounds!),
      ),
    );
  }

  BoundingBox _getBounds(List<Point> points) {
    final lngs = points.map<double>((m) => m.longitude).toList();
    final lats = points.map<double>((m) => m.latitude).toList();

    final highestLat = lats.reduce(max);
    final highestLng = lngs.reduce(max);
    final lowestLat = lats.reduce(min);
    final lowestLng = lngs.reduce(min);

    final distance = sqrt(
      pow(lowestLat - highestLat, 2) + pow(lowestLng - highestLng, 2),
    );

    // От 0.001 до 1
    final offsetCoeff = max(
      min(distance / 10, 1),
      0.001,
    );

    return BoundingBox(
      southWest: Point(
        latitude: lowestLat - offsetCoeff,
        longitude: lowestLng - offsetCoeff,
      ),
      northEast: Point(
        latitude: highestLat + offsetCoeff,
        longitude: highestLng + offsetCoeff,
      ),
    );
  }

  Future<void> _updateUserPosition() async {
    mapObjectsStreamed.value
        .removeWhere((element) => element.mapId == userMapId);
    try {
      final position = await _tryGetUserPosition();

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
    } on CustomException catch (e) {
      showTopError(e);
    }
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

  Future<Point> _tryGetUserPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    CustomException? ex;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const CustomException(
        title: 'Невозможно определить местоположение',
      );
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw const CustomException(
          title: 'Невозможно определить местоположение',
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw const CustomException(
        title: 'Невозможно определить местоположение',
      );
    }

    final position = await Geolocator.getCurrentPosition();

    return Point(
      latitude: position.latitude,
      longitude: position.longitude,
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
