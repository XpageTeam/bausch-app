import 'dart:async';
import 'dart:typed_data';

import 'package:bausch/models/shop/shop_model.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final List<ShopModel> shopList;
  Point centerCoords = const Point(
    latitude: 0,
    longitude: 0,
  );

  // ignore: cancel_subscriptions
  StreamSubscription<Position>? subscription;

  Placemark? userPrevPlacemark;
  bool userPostUpdateSubscribed = false;

  // TODO(Nikolay): Добавить маркеры для пользователя.
  late Uint8List userMarkers;

  MapBloc({required this.shopList}) : super(MapInitialState()) {
    on<MapEvent>(
      (event, emit) async {
        //* Загрузка карты и меток магазинов
        if (event is MapShowPlacemarksEvent) {
          emit(MapLoadingState());
          emit(await _showPlacemarks());
          emit(MapSetCenterState(centerCoords: centerCoords));
        }

        //* Определение текущего местоположения
        if (event is MapGetCurrentLocationEvent ||
            event is MapUpdateCurrentLocationEvent) {
          emit(await _determinePosition());
        }

        //* Приближение карты
        if (event is MapZoomInEvent) {
          emit(MapZoomInState());
        }

        //* Отдаление карты
        if (event is MapZoomOutEvent) {
          emit(MapZoomOutState());
        }

        //* Получение информации о магазине
        if (event is MapShopInfoEvent) {
          emit(MapGetShopInfoState(shop: event.shop));
        }

        //* Изменение метки при выборе
        if (event is MapChangePlacemarkEvent) {
          emit(
            MapChangePlacemarkState(
              oldPlacemark: event.oldPlacemark,
              newPlacemark: event.newPlacemark,
            ),
          );
        }

        emit(MapInitialState());
      },
    );
  }

  @override
  Future<void> close() {
    if (subscription != null) subscription!.cancel();
    return super.close();
  }

  ///* Получение маркера магазина из ассетов
  Future<Uint8List> _getShopMarker() async {
    final data = await rootBundle.load('assets/icons/map-marker.png');
    return data.buffer.asUint8List();
  }

  ///* Метод получения меток магазинов
  Future<MapShowPlacemarksState> _showPlacemarks() async {
    final shopMarker = await _getShopMarker();
    final placemarks = <Placemark>[];

    for (final shop in shopList) {
      if (shop.coords == null) continue;

      centerCoords = Point(
        latitude: centerCoords.latitude + shop.coords!.latitude,
        longitude: centerCoords.longitude + shop.coords!.longitude,
      );

      shop.placemark = Placemark(
        point: Point(
          latitude: shop.coords!.latitude,
          longitude: shop.coords!.longitude,
        ),
        onTap: (point, tapReceiver) {
          add(
            MapShopInfoEvent(shop: shop),
          );
        },
        style: PlacemarkStyle(
          scale: 1.5,
          rawImageData: shopMarker,
          zIndex: 1,
          opacity: 1,
        ),
      );

      placemarks.add(shop.placemark!);
    }

    centerCoords = Point(
      latitude: centerCoords.latitude / placemarks.length,
      longitude: centerCoords.longitude / placemarks.length,
    );

    return MapShowPlacemarksState(placemarks: placemarks);
  }

  ///* Метод определения местоположения
  Future<MapState> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint('MapBloc: Геолокация выключена');
      return const MapFailedState(
        title: 'Служба геолокации выключена',
        text: 'необходимо включить её в настройках',
      );
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return const MapFailedState(
          title: 'Приложению был запрещён доступ к геоданным',
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return const MapFailedState(
        title: 'Приложению был запрещён доступ к геоданным',
      );
    }

    final position = await Geolocator.getCurrentPosition();

    final newUserPlacemark = Placemark(
      point: Point(latitude: position.latitude, longitude: position.longitude),
      // style: PlacemarkStyle(rawImageData: userMarker, zIndex: 1, opacity: 1),
    );

    final currentLocationState = MapGetCurrentLocationState(
      newPlacemark: newUserPlacemark,
      oldPlacemark: userPrevPlacemark,
    );

    userPrevPlacemark = newUserPlacemark;

    if (!userPostUpdateSubscribed) {
      debugPrint('MapBloc: Обновление геопозиции');
      subscription = Geolocator.getPositionStream().listen(
        (event) {
          debugPrint('MapBloc: Обновление геопозиции (listener)');
          MapGetCurrentLocationEvent();
        },
      );
      userPostUpdateSubscribed = true;
    }
    // TODO(Nikolay): При повторном нажитии на кнопку "показ текущего местоположения" должна отключаться прослушка текущего местоположения.

    return currentLocationState;
  }
}
