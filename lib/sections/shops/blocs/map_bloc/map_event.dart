part of 'map_bloc.dart';

@immutable
abstract class MapEvent {
  const MapEvent();
}

///* Приближение
class MapZoomInEvent extends MapEvent {}

///* Отдаление
class MapZoomOutEvent extends MapEvent {}

///* Показ текущей позиции
class MapGetCurrentLocationEvent extends MapEvent {}

///* Показ информации о магазине
class MapShopInfoEvent extends MapEvent {
  final ShopModel shop;

  const MapShopInfoEvent({required this.shop});
}

///* Показ меток магазинов на карте
class MapShowPlacemarksEvent extends MapEvent {}

///* Обновление
class MapUpdateCurrentLocationEvent extends MapEvent {}

///* Изменение метки при ее выборе
class MapChangePlacemarkEvent extends MapEvent {
  final Placemark oldPlacemark;
  final Placemark newPlacemark;

  const MapChangePlacemarkEvent({
    required this.oldPlacemark,
    required this.newPlacemark,
  });
}
