part of 'map_bloc.dart';

@immutable
abstract class MapState {
  const MapState();
}

class MapInitialState extends MapState {}

class MapLoadingState extends MapState {}

///* Приближение
class MapZoomInState extends MapState {}

///* Отдаление
class MapZoomOutState extends MapState {}

///* Показ текущей позиции
class MapGetCurrentLocationState extends MapState {
  final Placemark newPlacemark;
  final Placemark? oldPlacemark;

  const MapGetCurrentLocationState({
    required this.newPlacemark,
    this.oldPlacemark,
  });
}

///* Показ информации о магазине
class MapGetShopInfoState extends MapState {
  final ShopModel shop;

  const MapGetShopInfoState({
    required this.shop,
  });
}

///* Показ информации о магазине
class MapShowPlacemarksState extends MapState {
  final List<Placemark> placemarks;

  const MapShowPlacemarksState({required this.placemarks});
}

///* Зафакапленное состояние
class MapFailedState extends MapState {
  final String title;
  final String? text;

  const MapFailedState({
    required this.title,
    this.text,
  });
}

///* Центрирование по всем меткам
class MapSetCenterState extends MapState {
  final Point centerCoords;
  const MapSetCenterState({required this.centerCoords});
}

///* Изменение метки при ее выборе
class MapChangePlacemarkState extends MapState {
  final Placemark oldPlacemark;
  final Placemark newPlacemark;
  const MapChangePlacemarkState({
    required this.oldPlacemark,
    required this.newPlacemark,
  });
}
