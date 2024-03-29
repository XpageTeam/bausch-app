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
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image/image.dart' as IMG;
import 'package:surf_mwwm/surf_mwwm.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class MapBodyWM extends WidgetModel {
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

  final OpticShop? initialOptic;

  final zoomInAction = VoidAction();
  final zoomOutAction = VoidAction();
  final moveToUserPosition = VoidAction();

  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  double userDirection = 0;

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
  List<OpticShop> initOpticShops;

  MapBodyWM({
    required this.initOpticShops,
    required this.onCityDefinitionCallback,
    required this.isCertificateMap,
    required this.initialOptic,
  }) : super(
          const WidgetModelDependencies(),
        );

  @override
  void onBind() {
    moveToUserPosition.bind(
      (value) {
        _enableListenUserPosition();
        _listenUserDirection();
        // _updateUserPosition();
      },
    );

    zoomInAction.bind((_) {
      mapController?.moveCamera(
        CameraUpdate.zoomIn(),
        animation: const MapAnimation(
          duration: 0.2,
        ),
      );
    });

    zoomOutAction.bind((_) {
      mapController?.moveCamera(
        CameraUpdate.zoomOut(),
        animation: const MapAnimation(
          duration: 0.2,
        ),
      );
    });

    super.onBind();
  }

  @override
  void dispose() {
    mapController = null;
    mapObjectsStreamed.dispose();

    userPositionStream?.cancel();

    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }

  Future<void> init() async {
    if (initOpticShops.isEmpty) return;

    await updateMapObjects(
      initOpticShops,
      withSetCenter: initialOptic == null,
    );
  }

  Future<void> moveToInitialOptic(OpticShop? shop) async {
    if (shop != null) {
      final id = initOpticShops.indexOf(shop);
      debugPrint('id: $id');

      await _updateClusterMapObject(initOpticShops, id);
      await Future<void>.delayed(
        const Duration(milliseconds: 100),
      );
      unawaited(_moveTo(shop.coords));
      onPlacemarkPressed?.call(shop);
    }
  }

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
    initOpticShops = shopList;
    await Future<void>.delayed(
      const Duration(milliseconds: 100),
    );
    await _updateClusterMapObject(shopList);
    if (mapController != null && withSetCenter) {
      await setCenterOn<OpticShop>(
        shopList,
        withUserPosition: false,
      );
    }
  }

  Future<void> setCenterOn<T>(
    List<T> newList, {
    bool withUserPosition = true,
  }) async {
    if (newList.isEmpty) return;

    final list = newList;
    // debugPrint('list: $list');

    await Future<void>.delayed(
      const Duration(
        milliseconds: 100,
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
        milliseconds: 100,
      ),
      () async => mapController?.moveCamera(
        CameraUpdate.newBounds(bounds!),
        animation: const MapAnimation(
          duration: 0.1,
        ),
      ),
    );
  }

  Future<void> _updateClusterMapObject(
    List<OpticShop> shopList, [
    int? indexOfPressedShop,
  ]) async {
    final mapObjects = mapObjectsStreamed.value.toList()
      ..removeWhere(
        (obj) => obj.mapId == clusterMapId,
      );

    final placemarkCollection = ClusterizedPlacemarkCollection(
      mapId: clusterMapId,
      radius: 25,
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
      onClusterTap: (self, cluster) {
        // Если метка немного наложилась на кластер, то при нажатии надо проверять, произошло ли уже нажатие на метку
        if (isModalBottomSheetOpen.value) return;
        setCenterOn(
          cluster.placemarks,
          withUserPosition: false,
        );
      },
      placemarks: await _generatePlacemarks(
        shopList: shopList,
        indexOfPressedShop: indexOfPressedShop,
      ),
    );

    mapObjects.add(placemarkCollection);

    await mapObjectsStreamed.accept(mapObjects);
  }

  Future<List<PlacemarkMapObject>> _generatePlacemarks({
    required List<OpticShop> shopList,
    int? indexOfPressedShop,
  }) async {
    final list = <PlacemarkMapObject>[];

    for (var i = 0; i < shopList.length; i++) {
      final rnd = rng.nextInt(500);
      final placemarkId = 'p_${i}_${rnd}_${shopList[i].coords}';

      final icon = await _rawPlacemarkImage(
        shopList: shopList,
        currentPlacemarkIndex: i,
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
          point: shopList[i].coords,
          icon: PlacemarkIcon.single(
            PlacemarkIconStyle(
              anchor: const Offset(0.5, 1),
              scale: indexOfPressedShop != null
                  ? indexOfPressedShop == i
                      ? 1.2
                      : 0.75
                  : 0.75,
              image: BitmapDescriptor.fromBytes(icon),
            ),
          ),
        ),
      );
    }

    return list;
  }

  void _listenUserDirection() {
    if (FlutterCompass.events == null) return;

    _streamSubscriptions.add(
      FlutterCompass.events!.listen(
        (event) {
          if (userPosition == null) return;

          userDirection = event.heading ?? 0;
          mapObjectsStreamed.value.add(
            PlacemarkMapObject(
              mapId: userMapId,
              point: userPosition!,
              opacity: 1,
              direction: userDirection,
              icon: PlacemarkIcon.single(
                PlacemarkIconStyle(
                  scale: 0.75,
                  anchor: const Offset(0.5, 56 / 104),
                  rotationType: RotationType.rotate,
                  image: BitmapDescriptor.fromAssetImage(
                    'assets/icons/user-marker.png',
                  ),
                ),
              ),
            ),
          );

          unawaited(mapObjectsStreamed.accept(mapObjectsStreamed.value));
        },
      ),
    );
  }

  Future<void> _updateUserPosition({
    bool withMoveToUser = true,
    Point? newUserPosition,
  }) async {
    mapObjectsStreamed.value
        .removeWhere((element) => element.mapId == userMapId);

    userPosition = newUserPosition ?? await _getUserPosition();

    // mapObjectsStreamed.value.add(
    //   PlacemarkMapObject(
    //     mapId: userMapId,
    //     point: userPosition!,
    //     opacity: 1,
    //     direction: userDirection,
    //     icon: PlacemarkIcon.single(
    //       PlacemarkIconStyle(
    //         scale: 0.75,
    //         rotationType: RotationType.rotate,
    //         image: BitmapDescriptor.fromAssetImage(
    //           'assets/icons/user-marker.png',
    //         ),
    //       ),
    //     ),
    //   ),
    // );

    // unawaited(mapObjectsStreamed.accept(mapObjectsStreamed.value));
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
    LocationPermission permission;

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    // if (!serviceEnabled) {
    //   // onError
    //   onGetUserPositionError?.call(
    //     const CustomException(
    //       title: 'Невозможно определить местоположение',
    //     ),
    //   );
    // }

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
    debugPrint('possibleCities.first.data: ${possibleCities.first.data.city}');
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

    const size = Size(70, 70);

    final suluFillPaint = Paint()
      ..color = AppTheme.sulu
      ..style = PaintingStyle.fill;

    final mineShaftFillPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    final whiteFillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final radius = size.height / 2;

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
      (size.height - textPainter.height) / 2,
    );

    final circleOffset = Offset(size.width / 2, radius);

    canvas
      ..drawCircle(circleOffset, radius, whiteFillPaint)
      ..drawCircle(circleOffset, radius - 5, mineShaftFillPaint)
      ..drawCircle(circleOffset, radius - 12, suluFillPaint);

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
    int currentPlacemarkIndex = 0,
  }) async {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    const height = 100.0;
    const imageRatio = 99 / 121;

    const size = Size(height, height / imageRatio);

    final imageWidth = size.height * imageRatio;
    shopMarkerBase ??= await _loadUiImage(
      'assets/icons/shop-marker-base.png',
      size: size,
    );

    canvas.drawImage(
      shopMarkerBase!,
      Offset.zero,
      Paint(),
    );

    final circleSize = Size(size.height * 3 / 7, size.height * 3 / 7);

    final features = isCertificateMap &&
            shopList.isNotEmpty &&
            shopList.first is OpticShopForCertificate
        ? shopList
            .map((e) => e as OpticShopForCertificate)
            .toList()[currentPlacemarkIndex]
            .features
        : <OpticShopFeature>[];

    final isDiscount = features.any((feature) => feature.xmlId == 'discount');

    _drawDiagram(
      canvas: canvas,
      size: circleSize,
      center: Offset(imageWidth / 2, 47), // 47 хромосом у меня, да

      // сюда надо передавать количество уникальных фильтров, которые будут находиться в текущей оптике
      colors: isCertificateMap &&
              shopList.isNotEmpty &&
              shopList.first is OpticShopForCertificate
          ? _getColorsFromFeatures(features)
          : [AppTheme.sulu],
    );

    const discountCircleRadius = 25.0;

    if (isDiscount) {
      _drawDiscountCircle(
        size: size,
        canvas: canvas,
        radius: discountCircleRadius,
      );
    }

    final imageSize = isDiscount
        ? Size(
            size.width + discountCircleRadius / 2,
            size.height + discountCircleRadius / 2,
          )
        : size;

    final image = await recorder
        .endRecording()
        .toImage(imageSize.width.toInt(), imageSize.height.toInt());
    final pngBytes = await image.toByteData(format: ImageByteFormat.png);

    return pngBytes!.buffer.asUint8List();
  }

  void _drawDiscountCircle({
    required Size size,
    required Canvas canvas,
    required double radius,
  }) {
    canvas.drawCircle(
      Offset(
        size.width - radius,
        radius,
      ),
      radius,
      Paint()..color = AppTheme.sulu,
    );

    final textPainter = TextPainter(
      text: TextSpan(
        text: '%',
        style: AppStyles.n1.copyWith(fontSize: 35),
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: size.width);

    final textOffset = Offset(
      size.width - 42,
      6,
    );

    textPainter.paint(canvas, textOffset);
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

  List<Color> _getColorsFromFeatures(List<OpticShopFeature> features) {
    if (features.isEmpty) return [AppTheme.sulu];

    return features.fold(
      <Color>{},
      // ignore: no-equal-then-else
      (colors, feature) {
        if (feature.color == null) return colors;

        colors.add(feature.color!);
        return colors;
      },
    ).toList();
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
