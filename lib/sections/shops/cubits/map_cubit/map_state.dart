part of 'map_cubit.dart';

@immutable
abstract class MapState {}

class MapInitial extends MapState {}

class MapZoomIn extends MapState {}

class MapZoomOut extends MapState {}

class MapSetCenter extends MapState {
  final double zoom;
  final MapAnimation? mapAnimation;
  final Point point;
  MapSetCenter({
    required this.zoom,
    required this.point,
    this.mapAnimation,
  });
}

class MapFailed extends MapState {
  final String title;
  final String? text;

  MapFailed({
    required this.title,
    this.text,
  });
}

class MapUpdateCurrentLocation extends MapState {}

class MapRemovePlacemark extends MapState {
  final Placemark? placemark;

  MapRemovePlacemark({required this.placemark});
}

class MapAddPlacemark extends MapState {
  final Placemark placemark;

  MapAddPlacemark({required this.placemark});
}

class MapShowModalBottomSheet extends MapState {
  final ShopModel shopModel;

  MapShowModalBottomSheet({required this.shopModel});
}
