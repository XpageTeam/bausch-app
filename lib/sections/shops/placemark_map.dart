import 'package:bausch/sections/shops/test_map.dart';
import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class PlacemarkPage extends StatefulWidget {
  const PlacemarkPage({Key? key}) : super(key: key);

  @override
  PlacemarkExampleState createState() => PlacemarkExampleState();
}

class PlacemarkExampleState extends State<PlacemarkPage> {
  final List<MapObject> mapObjects = [];

  final MapObjectId placemarkId = const MapObjectId('normal_icon_placemark');
  final MapObjectId placemarkWithDynamicIconId =
      const MapObjectId('dynamic_icon_placemark');
  final MapObjectId placemarkWithCompositeIconId =
      const MapObjectId('composite_icon_placemark');

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(child: YandexMap(mapObjects: mapObjects)),
        SizedBox(height: 20),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('Placemark with Assets Icon:'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    ControlButton(
                      onPressed: () async {
                        if (mapObjects.any((el) => el.mapId == placemarkId)) {
                          return;
                        }

                        final placemark = Placemark(
                          mapId: placemarkId,
                          point:
                              Point(latitude: 59.945933, longitude: 30.320045),
                          onTap: (Placemark self, Point point) =>
                              debugPrint('Tapped me at $point'),
                          opacity: 0.7,
                          direction: 90,
                          icon: PlacemarkIcon.single(
                            PlacemarkIconStyle(
                              image: BitmapDescriptor.fromAssetImage(
                                'assets/icons/map-marker.png',
                              ),
                              rotationType: RotationType.rotate,
                            ),
                          ),
                        );

                        setState(() {
                          mapObjects.add(placemark);
                        });
                      },
                      title: 'Add',
                    ),
                    ControlButton(
                      onPressed: () async {
                        if (!mapObjects.any((el) => el.mapId == placemarkId)) {
                          return;
                        }

                        final placemark = mapObjects.firstWhere(
                          (el) => el.mapId == placemarkId,
                        ) as Placemark;

                        setState(
                          () {
                            mapObjects[mapObjects.indexOf(placemark)] =
                                placemark.copyWith(
                              point: Point(
                                latitude: placemark.point.latitude - 1,
                                longitude: placemark.point.longitude - 1,
                              ),
                            );
                          },
                        );
                      },
                      title: 'Update',
                    ),
                    ControlButton(
                      onPressed: () async {
                        setState(() {
                          mapObjects
                              .removeWhere((el) => el.mapId == placemarkId);
                        });
                      },
                      title: 'Remove',
                    ),
                  ],
                ),
                Text('Placemark with Binary Icon:'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    ControlButton(
                      onPressed: () async {
                        if (mapObjects.any(
                          (el) => el.mapId == placemarkWithDynamicIconId,
                        )) {
                          return;
                        }

                        final placemarkWithDynamicIcon = Placemark(
                          mapId: placemarkWithDynamicIconId,
                          point: const Point(
                            latitude: 30.320045,
                            longitude: 59.945933,
                          ),
                          onTap: (Placemark self, Point point) async {
                            if (!mapObjects.any(
                              (el) => el.mapId == placemarkWithDynamicIconId,
                            )) {
                              return;
                            }

                            final placemarkWithDynamicIcon =
                                mapObjects.firstWhere(
                              (el) => el.mapId == placemarkWithDynamicIconId,
                            ) as Placemark;

                            setState(() {
                              mapObjects[mapObjects
                                      .indexOf(placemarkWithDynamicIcon)] =
                                  placemarkWithDynamicIcon.copyWith(
                                icon: PlacemarkIcon.single(
                                  PlacemarkIconStyle(
                                    scale: 1.5,
                                    image: BitmapDescriptor.fromAssetImage(
                                      'assets/icons/user-marker.png',
                                    ),
                                  ),
                                ),
                              );
                            });
                          },
                          opacity: 0.95,
                          icon: PlacemarkIcon.single(
                            PlacemarkIconStyle(
                              image: BitmapDescriptor.fromAssetImage(
                                'assets/icons/user-marker.png',
                              ),
                            ),
                          ),
                        );

                        setState(() {
                          mapObjects.add(placemarkWithDynamicIcon);
                        });
                      },
                      title: 'Add',
                    ),
                    ControlButton(
                      onPressed: () async {
                        if (!mapObjects.any(
                          (el) => el.mapId == placemarkWithDynamicIconId,
                        )) {
                          return;
                        }

                        final placemarkWithDynamicIcon = mapObjects.firstWhere(
                          (el) => el.mapId == placemarkWithDynamicIconId,
                        ) as Placemark;

                        setState(() {
                          mapObjects[mapObjects
                                  .indexOf(placemarkWithDynamicIcon)] =
                              placemarkWithDynamicIcon.copyWith(
                            icon: PlacemarkIcon.single(
                              PlacemarkIconStyle(
                                scale: 1.5,
                                image: BitmapDescriptor.fromAssetImage(
                                  'assets/icons/user-marker.png',
                                ),
                              ),
                            ),
                            point: Point(
                              latitude:
                                  placemarkWithDynamicIcon.point.latitude + 1,
                              longitude:
                                  placemarkWithDynamicIcon.point.longitude + 1,
                            ),
                          );
                        });
                      },
                      title: 'Update',
                    ),
                    ControlButton(
                        onPressed: () async {
                          setState(() {
                            mapObjects.removeWhere(
                                (el) => el.mapId == placemarkWithDynamicIconId);
                          });
                        },
                        title: 'Remove'),
                  ],
                ),
                const Text('Placemark with Composite Icon:'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    ControlButton(
                        onPressed: () async {
                          if (mapObjects.any((el) =>
                              el.mapId == placemarkWithCompositeIconId)) {
                            return;
                          }

                          final placemarkWithCompositeIcon = Placemark(
                            mapId: placemarkWithCompositeIconId,
                            point: const Point(
                                latitude: 34.820045, longitude: 45.945933),
                            onTap: (Placemark self, Point point) =>
                                debugPrint('Tapped me at $point'),
                            icon: PlacemarkIcon.composite(
                              [
                                PlacemarkCompositeIconItem(
                                  name: 'user',
                                  style: PlacemarkIconStyle(
                                    image: BitmapDescriptor.fromAssetImage(
                                        'lib/assets/user.png'),
                                    anchor: Offset(0.5, 0.5),
                                  ),
                                ),
                                PlacemarkCompositeIconItem(
                                  name: 'arrow',
                                  style: PlacemarkIconStyle(
                                    image: BitmapDescriptor.fromAssetImage(
                                      'lib/assets/arrow.png',
                                    ),
                                    anchor: Offset(0.5, 1.5),
                                  ),
                                ),
                              ],
                            ),
                            opacity: 0.7,
                          );

                          setState(() {
                            mapObjects.add(placemarkWithCompositeIcon);
                          });
                        },
                        title: 'Add'),
                    ControlButton(
                        onPressed: () async {
                          if (!mapObjects.any((el) =>
                              el.mapId == placemarkWithCompositeIconId)) {
                            return;
                          }

                          final placemarkWithCompositeIcon =
                              mapObjects.firstWhere((el) =>
                                      el.mapId == placemarkWithCompositeIconId)
                                  as Placemark;

                          setState(() {
                            mapObjects[mapObjects
                                    .indexOf(placemarkWithCompositeIcon)] =
                                placemarkWithCompositeIcon.copyWith(
                              point: Point(
                                  latitude: placemarkWithCompositeIcon
                                          .point.latitude +
                                      1,
                                  longitude: placemarkWithCompositeIcon
                                          .point.longitude +
                                      1),
                            );
                          });
                        },
                        title: 'Update'),
                    ControlButton(
                      onPressed: () async {
                        setState(() {
                          mapObjects.removeWhere(
                              (el) => el.mapId == placemarkWithCompositeIconId);
                        });
                      },
                      title: 'Remove',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
