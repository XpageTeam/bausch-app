import 'dart:typed_data';

import 'package:bausch/models/shop/shop_model.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

part 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  /// Список магазинов
  final List<ShopModel> shopList;

  /// Координаты пользователя
  Point? userPoint;

  /// Метка пользователя
  Placemark? userPlacemark;

  /// Метка магазина (для того, чтобы выделять)
  Placemark? shopPlacemark;

  MapCubit({
    required this.shopList,
  }) : super(MapInitial());

  /// Приближение
  void zoomIn() => emit(MapZoomIn());

  /// Отдаление
  void zoomOut() => emit(MapZoomOut());

  /// Показ текущего местоположения
  Future<void> showCurrentLocation() async {
    emit(
      MapRemovePlacemark(placemark: userPlacemark),
    );

    final state = await _addNewPosition();

    emit(state);

    if (state is! MapFailed) {
      emit(
        MapSetCenter(
          zoom: 14,
          point: userPoint!,
          mapAnimation: const MapAnimation(),
        ),
      );
    }
  }

  /// Изменение метки при ее выборе
  void changePlacemark({
    required Placemark placemark,
    required bool isOpenning,
  }) {
    emit(
      MapRemovePlacemark(
        placemark: isOpenning ? placemark : shopPlacemark,
      ),
    );

    shopPlacemark = Placemark(
      point: placemark.point,
      onTap: placemark.onTap,
      style: PlacemarkStyle(
        zIndex: 1,
        opacity: 1,
        scale: 1.5,
        rawImageData: placemark.style.rawImageData,
      ),
    );

    emit(
      MapAddPlacemark(
        placemark: isOpenning ? shopPlacemark! : placemark,
      ),
    );
  }

  // Центрирование на магазинах
  void setCenterOnShops() {
    // Получение списка меток
    final placemarkList = shopList
        .where(
          (shop) => shop.defaultPlacemark != null,
        )
        .map((shop) => shop.defaultPlacemark!)
        .toList();

    //* Если меток нет, тогда просто показываю пользователю его текущее местоположение
    if (placemarkList.isEmpty) {
      showCurrentLocation();
    } else {
      //* Иначе - вычисляю среднюю координату и
      final middlePoint = _calcMiddlePoint(
        placemarkList,
      );

      emit(
        MapSetCenter(zoom: 12, point: middlePoint),
      );
    }
  }

  Future<Uint8List> getRawImageData(String imageAsset) async {
    final data = await rootBundle.load(imageAsset);
    return data.buffer.asUint8List();
  }

  /// Метод вычисления средней координаты
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

  /// Метод определения местоположения
  Future<MapState> _addNewPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return MapFailed(
        title: 'Невозможно определить местоположение',
      );
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return MapFailed(
          title: 'Невозможно определить местоположение',
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return MapFailed(
        title: 'Невозможно определить местоположение',
      );
    }

    final position = await Geolocator.getCurrentPosition();
    userPoint = Point(
      latitude: position.latitude,
      longitude: position.longitude,
    );

    // TODO(Nikolay): Скорее всего это надо будет убрать в другое место.
    userPlacemark = Placemark(
      point: userPoint!,
      style: PlacemarkStyle(
        rawImageData: await getRawImageData('assets/icons/user-marker.png'),
      ),
    );

    return MapAddPlacemark(
      placemark: userPlacemark!,
    );
  }
}
