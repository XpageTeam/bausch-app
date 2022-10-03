// ignore_for_file: library_prefixes

import 'dart:async';
import 'dart:math';
import 'dart:ui' as UI;

import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/models/city/dadata_cities_downloader.dart';
import 'package:bausch/models/dadata/dadata_response_data_model.dart';
import 'package:bausch/models/shop/shop_model.dart';
import 'package:bausch/sections/sheets/screens/discount_optics/widget_models/discount_optics_screen_wm.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image/image.dart' as IMG;
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

  // final setCenterAction = StreamedAction<List<OpticShop>>();
  // final updateMapObjects = StreamedAction<List<OpticShop>>();
  // final updateMapObjectsWhenComplete = StreamedAction<List<OpticShop>>();

  final isModalBottomSheetOpen = StreamedState<bool>(false);

  /// Для карты, которая из страницы сертификата открывается немного другая логика отображения меток на карте
  final bool isCertificateMap;

  final zoomInAction = VoidAction();
  final zoomOutAction = VoidAction();
  final moveToUserPosition = VoidAction();

  YandexMapController? mapController;

  void Function(OpticShop shop)? onPlacemarkPressed;
  void Function(CustomException exception)? onGetUserPositionError;

  Random rng = Random();

  Point? userPosition;

  // Картинка основы для маркеров оптик.
  // Вынес сюда для увеличения производительности, т.к. каждый раз читать картинку оказалось очень долго
  UI.Image? shopMarkerBase;

  /// Поток местоположения пользователя
  StreamSubscription<Position>? userPositionStream;

  MapBodyWM({
    required this.initOpticShops,
    required this.onCityDefinitionCallback,
    required this.isCertificateMap,
  }) : super(
          const WidgetModelDependencies(),
        );

  @override
  void onBind() {
    // updateMapObjects.bind((shopList) async {
    //   await _updateClusterMapObject(shopList!);
    //   if (mapController != null) {
    //     _setCenterOn<OpticShop>(shopList);
    //   }
    // });

    // updateMapObjectsWhenComplete.bind((shopList) {
    //   _updateClusterMapObject(shopList!);
    // });

    moveToUserPosition.bind(
      (value) {
        _enableListenUserPosition();
        // _updateUserPosition();
      },
    );

    // setCenterAction.bind(
    //   (opticShops) => setCenterOn(opticShops!),
    // );

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

  @override
  void onLoad() {
    // Пришлось обернуть в future, потому что иногда метки не отрисовывались
    Future<void>.delayed(
      const Duration(milliseconds: 300),
      () => updateMapObjects(initOpticShops),
    );
    super.onLoad();
  }

  @override
  void dispose() {
    // mapController?.dispose();
    mapController = null;

    userPositionStream?.cancel();
    super.dispose();
  }
  // Future<List<Uint8List>> _getIcons({
  //   required List<OpticShop> shopList,
  //   int? indexOfPressedShop,
  // }) async {
  //   final list = <Uint8List>[];
  //   for (var i = 0; i < shopList.length; i++) {
  //     list.add(await _rawPlacemarkImage());
  //   }

  //   return list;
  // }

  void updateMapObjectsWhenComplete(List<OpticShop> shopList) {
    updateMapObjects(
      shopList,
      withSetCenter: false,
    );
  }

  Future<void> updateMapObjects(
    List<OpticShop> shopList, {
    bool withSetCenter = true,
  }) async {
    await _updateClusterMapObject(shopList);
    if (mapController != null && withSetCenter) {
      unawaited(setCenterOn<OpticShop>(shopList));
    }
  }

  Future<void> setCenterOn<T>(
    List<T> newList, {
    bool withUserPosition = true,
  }) async {
    // TODO(Nikolay): Возможно надо будет центрироваться на позиции пользователя, если список пуст.
    if (newList.isEmpty) return;

    final list = newList;
    debugPrint('list: $list');

    await Future<void>.delayed(
      const Duration(
        milliseconds: 200,
      ),
    );

    BoundingBox? bounds;

    if (list is List<Point>) {
      bounds = _getBounds(
        list as List<Point>,
        withUserPosition: withUserPosition,
      );
    } else if (list is List<PlacemarkMapObject>) {
      bounds = _getBounds(
        (list as List<PlacemarkMapObject>).map((e) => e.point).toList(),
        withUserPosition: withUserPosition,
      );
    } else if (list is List<ShopModel>) {
      bounds = _getBounds(
        (list as List<ShopModel>).map((e) => e.coords!).toList(),
        withUserPosition: withUserPosition,
      );
    } else if (list is List<OpticShop>) {
      bounds = _getBounds(
        (list as List<OpticShop>).map((e) => e.coords).toList(),
        withUserPosition: withUserPosition,
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

  Future<void> _updateClusterMapObject(
    List<OpticShop> shopList, [
    int? indexOfPressedShop,
  ]) async {
    mapObjectsStreamed.value.removeWhere(
      (obj) => obj.mapId == clusterMapId,
    );

    // final icons = await _getIcons(
    //   shopList: shopList,
    //   indexOfPressedShop: indexOfPressedShop,
    // );

    final placemarkCollection = ClusterizedPlacemarkCollection(
      mapId: clusterMapId,
      radius: 20,
      minZoom: 12,
      onClusterAdded: (
        self,
        cluster,
      ) async {
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
      onClusterTap: (self, cluster) => setCenterOn(
        cluster.placemarks,
        withUserPosition: false,
      ),
      placemarks: await _generatePlacemarks(
        shopList: shopList,
        indexOfPressedShop: indexOfPressedShop,
      ),
    );

    mapObjectsStreamed.value.add(placemarkCollection);
    unawaited(mapObjectsStreamed.accept(mapObjectsStreamed.value));
  }

  Future<List<PlacemarkMapObject>> _generatePlacemarks({
    required List<OpticShop> shopList,
    int? indexOfPressedShop,
  }) async {
    final list = <PlacemarkMapObject>[];

    for (var i = 0; i < shopList.length; i++) {
      final rnd = rng.nextInt(200);
      final placemarkId = 'p_${i}_${rnd}_${shopList[i].coords}';

      final icon = await _rawPlacemarkImage(
        shopList: shopList,
        indexOfPressedShop: indexOfPressedShop,
      );

      list.add(
        PlacemarkMapObject(
          onTap: (placemark, point) {
            _updateClusterMapObject(shopList, i);
            _moveTo(placemark.point);
            onPlacemarkPressed?.call(shopList[i]);
          },
          opacity: 1,
          mapId: MapObjectId(placemarkId),
          // MapObjectId('placemark_${shopList[i].coords}'),
          point: shopList[i].coords,
          icon: PlacemarkIcon.single(
            PlacemarkIconStyle(
              // scale: 0.75,
              scale: indexOfPressedShop != null
                  ? indexOfPressedShop == i
                      ? 1.2
                      : 0.75
                  : 0.75,
              image: BitmapDescriptor.fromBytes(icon),
              //   indexOfPressedShop != null
              //       ? indexOfPressedShop == i
              //           ? 'assets/icons/big-shop-marker.png'
              //           : 'assets/icons/shop-marker.png'
              //       : 'assets/icons/shop-marker.png',
              // ),
            ),
          ),
        ),
      );
    }

    // debugPrint('list len: ${list.length}');

    return list;
  }

  Future<void> _updateUserPosition({
    bool withMoveToUser = true,
    Point? newUserPosition,
  }) async {
    mapObjectsStreamed.value
        .removeWhere((element) => element.mapId == userMapId);

    userPosition = newUserPosition ?? await _getUserPosition();

    mapObjectsStreamed.value.add(
      PlacemarkMapObject(
        mapId: userMapId,
        point: userPosition!,
        opacity: 1,
        icon: PlacemarkIcon.single(
          PlacemarkIconStyle(
            scale: 0.75,
            image: BitmapDescriptor.fromAssetImage(
              'assets/icons/user-marker.png',
            ),
          ),
        ),
      ),
    );

    unawaited(mapObjectsStreamed.accept(mapObjectsStreamed.value));
    if (withMoveToUser) unawaited(_moveTo(userPosition!));
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

  Future<void> _enableListenUserPosition() async {
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
    unawaited(_updateUserPosition(
      newUserPosition: Point(
        latitude: position.latitude,
        longitude: position.longitude,
      ),
    ));

    await _trySetCityByUserPosition(position);

    await userPositionStream?.cancel();

    userPositionStream = Geolocator.getPositionStream().listen(
      (position) {
        _updateUserPosition(
          withMoveToUser: false,
          newUserPosition: Point(
            latitude: position.latitude,
            longitude: position.longitude,
          ),
        );
      },
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

  BoundingBox _getBounds(List<Point> points, {bool withUserPosition = true}) {
    if (mapObjectsStreamed.value.any((mapObj) => mapObj.mapId == userMapId) &&
        userPosition != null &&
        withUserPosition) {
      points.add(userPosition!);
    }

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
      northEast: Point(
        latitude: highestLat + offset,
        longitude: highestLng + offset,
      ),
      southWest: Point(
        latitude: lowestLat - offset,
        longitude: lowestLng - offset,
      ),
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

    final suluFillPaint = Paint()
      ..color = AppTheme.sulu
      ..style = PaintingStyle.fill;

    final mineShaftFillPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    final whiteFillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    // final suluFillPaint = Paint()
    //   ..color = AppTheme.sulu
    //   ..style = PaintingStyle.fill;

    const radius = 27.0; // min(max(cluster.size * 6.0, 30), 50).toDouble();

    final textPainter = TextPainter(
      text: TextSpan(
        text: cluster.size.toString(),
        style: AppStyles.h2Bold.copyWith(
          fontSize: 35,
          color: Colors.black,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: size.width);

    final textOffset = Offset(
      (size.width - textPainter.width) / 2,
      (size.height - textPainter.height) / 2 - 10,
    );

    final circleOffset = Offset(size.width / 2, size.height / 2 - 10);

    canvas
      ..drawCircle(circleOffset, radius + 12, whiteFillPaint)
      ..drawCircle(circleOffset, radius + 8, mineShaftFillPaint)
      ..drawCircle(circleOffset, radius, suluFillPaint);

    textPainter.paint(canvas, textOffset);

    final image = await recorder
        .endRecording()
        .toImage(size.width.toInt(), size.height.toInt());
    final pngBytes = await image.toByteData(format: ImageByteFormat.png);

    return pngBytes!.buffer.asUint8List();
  }

  Future<Uint8List> _rawPlacemarkImage({
    required List<OpticShop> shopList,
    int? indexOfPressedShop,
  }) async {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    const size = Size(300, 300);

    const imageRatio = 99 / 121;

    final imageWidth = size.height * imageRatio;
    shopMarkerBase ??= await _loadUiImage(
      'assets/icons/shop-marker-base.png',
      size: size / 2,
    );
    canvas.drawImage(
      shopMarkerBase!,
      Offset((size.width - imageWidth / 2) / 2, 0),
      Paint(),
    );

    final circleSize = Size(size.height / 5 + 5, size.height / 5 + 5);

    _drawDiagram(
      canvas: canvas,
      size: circleSize,
      center: Offset(
        (size.width) / 2 + 1,
        circleSize.height / 2 + 26, // (я не смог сделать нормально)
      ),
      // сюда надо передавать количество уникальных фильтров, которые будут находиться в текущей оптике
      colors: isCertificateMap
          ? [
              AppTheme.turquoiseBlue,
              AppTheme.orangeToric,
              AppTheme.yellowMultifocal,
            ]
          : [AppTheme.sulu],
    );

    final image = await recorder
        .endRecording()
        .toImage(size.width.toInt(), size.height.toInt());
    final pngBytes = await image.toByteData(format: ImageByteFormat.png);

    return pngBytes!.buffer.asUint8List();
  }

  void _drawDiagram({
    required Canvas canvas,
    required Offset center,
    required Size size,
    required List<Color> colors,
  }) {
    for (var i = 0; i < colors.length; i++) {
      _drawSegment(
        canvas: canvas,
        size: size,
        colors: colors,
        currentSegment: i,
        center: center,
      );
    }
  }

  Future<UI.Image> _loadUiImage(
    String imageAssetPath, {
    required Size size,
  }) async {
    final data = await rootBundle.load(imageAssetPath);

    final image = IMG.decodeImage(data.buffer.asUint8List().toList())!;
    final resized = IMG.copyResize(
      image,
      height: size.height.toInt(),
    );
    final resizedBytes = IMG.encodePng(resized);
    final completer = Completer<UI.Image>();

    UI.decodeImageFromList(
      Uint8List.fromList(resizedBytes),
      completer.complete,
    );
    return completer.future;
  }

  // final colors = [
  //   AppTheme.sulu,
  //   AppTheme.orangeToric,
  //   AppTheme.yellowMultifocal,
  //   Colors.red,
  //   Colors.green,
  //   Colors.purple,
  //   Colors.amber,
  // ];

  void _drawSegment({
    required Canvas canvas,
    required Size size,
    required Offset center,
    required List<Color> colors,
    required int currentSegment,
  }) {
    final count = colors.length;

    final paint = Paint()
      ..color = colors[currentSegment]
      ..style = PaintingStyle.fill;

    final initOffset =
        count > 2 ? pi * 3 / 2 - ((pi * 2 * (count - 1)) / count) : 0;

    final segmentAngle = pi * 2 / count;
    final startAngle = initOffset + currentSegment * segmentAngle;

    Path? path;

    if (count <= 1) {
      path = Path()
        ..addOval(
          Rect.fromCircle(
            center: center,
            radius: size.width / 2,
          ),
        );
    } else {
      path = Path()
        ..arcTo(
          Rect.fromCircle(
            center: center,
            radius: size.width / 2,
          ),
          startAngle,
          segmentAngle,
          false,
        )
        ..lineTo(center.dx, center.dy)
        ..close();
    }

    canvas.drawPath(path, paint);
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
