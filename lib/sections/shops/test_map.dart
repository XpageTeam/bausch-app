import 'package:bausch/sections/shops/clusterized_map_body.dart';
import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class MapControlsPage extends StatelessWidget {
  const MapControlsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _MapControlsExample();
  }
}

class _MapControlsExample extends StatefulWidget {
  @override
  _MapControlsExampleState createState() => _MapControlsExampleState();
}

class _MapControlsExampleState extends State<_MapControlsExample> {
  late YandexMapController controller;
  static const Point _point = Point(latitude: 59.945933, longitude: 30.320045);
  final List<MapObject> mapObjects = [];

  final MapObjectId targetMapObjectId = MapObjectId('target_placemark');

  final String emptyStyle = '''
    [
      {
        "tags": {
          "all": ["landscape"]
        },
        "stylers": {
          "saturation": 0,
          "lightness": 0
        }
      }
    ]
  ''';
  final String nonEmptyStyle = '''
    [
      {
        "tags": {
          "all": ["landscape"]
        },
        "stylers": {
          "color": "f00",
          "saturation": 0.5,
          "lightness": 0.5
        }
      }
    ]
  ''';

  bool tiltGesturesEnabled = true;
  bool zoomGesturesEnabled = true;
  bool rotateGesturesEnabled = true;
  bool scrollGesturesEnabled = true;
  bool modelsEnabled = true;
  bool nightModeEnabled = false;
  bool fastTapEnabled = false;
  bool mode2DEnabled = false;
  bool indoorEnabled = false;
  bool liteModeEnabled = false;

  double _height = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child: YandexMap(
            tiltGesturesEnabled: tiltGesturesEnabled,
            zoomGesturesEnabled: zoomGesturesEnabled,
            rotateGesturesEnabled: rotateGesturesEnabled,
            scrollGesturesEnabled: scrollGesturesEnabled,
            modelsEnabled: modelsEnabled,
            nightModeEnabled: nightModeEnabled,
            fastTapEnabled: fastTapEnabled,
            mode2DEnabled: mode2DEnabled,
            indoorEnabled: indoorEnabled,
            liteModeEnabled: liteModeEnabled,
            mapObjects: mapObjects,
            onMapCreated: (YandexMapController yandexMapController) async {
              controller = yandexMapController;

              final cameraPosition = await controller.getCameraPosition();
              final minZoom = await controller.getMinZoom();
              final maxZoom = await controller.getMaxZoom();

              debugPrint('Camera position: $cameraPosition');
              debugPrint('Min zoom: $minZoom, Max zoom: $maxZoom');
            },
            onMapSizeChanged: (MapSize size) =>
                debugPrint('Map size changed to $size'),
            onMapTap: (Point point) => debugPrint('Tapped map at $point'),
            onMapLongTap: (Point point) =>
                debugPrint('Long tapped map at $point'),
            onCameraPositionChanged: (
              CameraPosition cameraPosition,
              CameraUpdateReason reason,
              bool finished,
            ) {
              debugPrint('Camera position: $cameraPosition, Reason: $reason');

              if (finished) {
                debugPrint('Camera position movement has been finished');
              }
            },
          ),
        ),
        SizedBox(height: _height),
        const SizedBox(height: 20),
        Expanded(
          child: SingleChildScrollView(
            child: Table(
              children: <TableRow>[
                TableRow(
                  children: <Widget>[
                    ControlButton(
                      onPressed: () async {
                        await controller.setBounds(
                          boundingBox: const BoundingBox(
                            northEast: Point(latitude: 65.0, longitude: 40.0),
                            southWest: Point(latitude: 60.0, longitude: 30.0),
                          ),
                        );
                      },
                      title: 'Set bounds',
                    ),
                    ControlButton(
                      onPressed: () async {
                        await controller.move(
                          cameraPosition: const CameraPosition(target: _point),
                          animation:
                              const MapAnimation(smooth: true, duration: 2.0),
                        );
                      },
                      title: 'Move',
                    ),
                  ],
                ),
                TableRow(
                  children: <Widget>[
                    ControlButton(
                      onPressed: () => controller.zoomIn(),
                      title: 'Zoom in',
                    ),
                    ControlButton(
                      onPressed: () => controller.zoomOut(),
                      title: 'Zoom out',
                    ),
                  ],
                ),
                TableRow(
                  children: <Widget>[
                    ControlButton(
                      onPressed: () async {
                        final placemark = Placemark(
                          mapId: targetMapObjectId,
                          point: (await controller.getCameraPosition()).target,
                          opacity: 0.7,
                          icon: PlacemarkIcon.single(
                            PlacemarkIconStyle(
                              image: BitmapDescriptor.fromAssetImage(
                                'lib/assets/place.png',
                              ),
                            ),
                          ),
                        );

                        setState(
                          () {
                            mapObjects
                              ..removeWhere(
                                (el) => el.mapId == targetMapObjectId,
                              )
                              ..add(placemark);
                          },
                        );
                      },
                      title: 'Target point',
                    ),
                    ControlButton(
                      onPressed: () async {
                        await controller.logoAlignment(
                          alignment: const MapAlignment(
                            horizontal: HorizontalAlignment.center,
                            vertical: VerticalAlignment.bottom,
                          ),
                        );
                      },
                      title: 'Logo position',
                    ),
                  ],
                ),
                TableRow(
                  children: <Widget>[
                    ControlButton(
                      onPressed: () async {
                        await controller.setMapStyle(style: nonEmptyStyle);
                      },
                      title: 'Set Style',
                    ),
                    ControlButton(
                      onPressed: () async {
                        await controller.setMapStyle(style: emptyStyle);
                      },
                      title: 'Remove style',
                    ),
                  ],
                ),
                TableRow(
                  children: <Widget>[
                    ControlButton(
                      onPressed: () async {
                        setState(
                          () {
                            _height = _height == 0 ? 10 : 0;
                          },
                        );
                      },
                      title: 'Change size',
                    ),
                    Container(),
                  ],
                ),
                TableRow(
                  children: <Widget>[
                    ControlButton(
                      onPressed: () async {
                        await controller.setFocusRect(
                          screenRect: const ScreenRect(
                            bottomRight: ScreenPoint(x: 600, y: 600),
                            topLeft: ScreenPoint(x: 200, y: 200),
                          ),
                        );
                      },
                      title: 'Focus rect',
                    ),
                    ControlButton(
                      onPressed: () async {
                        await controller.clearFocusRect();
                      },
                      title: 'Clear focus rect',
                    ),
                  ],
                ),
                TableRow(
                  children: <Widget>[
                    ControlButton(
                      onPressed: () async {
                        final region = await controller.getFocusRegion();
                        debugPrint(
                          'TopLeft: ${region.topLeft}, BottomRight: ${region.bottomRight}',
                        );
                      },
                      title: 'Focus region',
                    ),
                    ControlButton(
                      onPressed: () async {
                        final region = await controller.getVisibleRegion();
                        debugPrint(
                          'TopLeft: ${region.topLeft}, BottomRight: ${region.bottomRight}',
                        );
                      },
                      title: 'Visible region',
                    ),
                  ],
                ),
                TableRow(
                  children: <Widget>[
                    ControlButton(
                      onPressed: () async {
                        final screenPoint = await controller.getScreenPoint(
                          (await controller.getCameraPosition()).target,
                        );

                        // debugPrint(screenPoint);
                      },
                      title: 'Map point to screen',
                    ),
                    ControlButton(
                      onPressed: () async {
                        final mediaQuery = MediaQuery.of(context);
                        final point = await controller.getPoint(
                          ScreenPoint(
                            x: mediaQuery.size.width,
                            y: mediaQuery.size.height,
                          ),
                        );

                        // debugPrint(point);
                      },
                      title: 'Screen point to map',
                    ),
                  ],
                ),
                TableRow(
                  children: <Widget>[
                    ControlButton(
                      onPressed: () async {
                        setState(() {
                          tiltGesturesEnabled = !tiltGesturesEnabled;
                        });
                      },
                      title:
                          'Tilt gestures: ${_enabledText(tiltGesturesEnabled)}',
                    ),
                    ControlButton(
                      onPressed: () async {
                        setState(
                          () {
                            rotateGesturesEnabled = !rotateGesturesEnabled;
                          },
                        );
                      },
                      title:
                          'Rotate gestures: ${_enabledText(rotateGesturesEnabled)}',
                    ),
                  ],
                ),
                TableRow(
                  children: <Widget>[
                    ControlButton(
                      onPressed: () async {
                        setState(() {
                          zoomGesturesEnabled = !zoomGesturesEnabled;
                        });
                      },
                      title:
                          'Zoom gestures: ${_enabledText(zoomGesturesEnabled)}',
                    ),
                    ControlButton(
                      onPressed: () async {
                        setState(() {
                          scrollGesturesEnabled = !scrollGesturesEnabled;
                        });
                      },
                      title:
                          'Scroll gestures: ${_enabledText(scrollGesturesEnabled)}',
                    ),
                  ],
                ),
                TableRow(
                  children: <Widget>[
                    ControlButton(
                      onPressed: () async {
                        setState(() {
                          modelsEnabled = !modelsEnabled;
                        });
                      },
                      title: 'Models: ${_enabledText(modelsEnabled)}',
                    ),
                    ControlButton(
                      onPressed: () async {
                        setState(
                          () {
                            nightModeEnabled = !nightModeEnabled;
                          },
                        );
                      },
                      title: 'Night mode: ${_enabledText(nightModeEnabled)}',
                    ),
                  ],
                ),
                TableRow(
                  children: <Widget>[
                    ControlButton(
                      onPressed: () async {
                        setState(() {
                          fastTapEnabled = !fastTapEnabled;
                        });
                      },
                      title: 'Fast tap: ${_enabledText(fastTapEnabled)}',
                    ),
                    ControlButton(
                      onPressed: () async {
                        setState(
                          () {
                            mode2DEnabled = !mode2DEnabled;
                          },
                        );
                      },
                      title: '2D mode: ${_enabledText(mode2DEnabled)}',
                    ),
                  ],
                ),
                TableRow(
                  children: <Widget>[
                    ControlButton(
                      onPressed: () async {
                        setState(() {
                          indoorEnabled = !indoorEnabled;
                        });
                      },
                      title: 'Indoor mode: ${_enabledText(indoorEnabled)}',
                    ),
                    ControlButton(
                      onPressed: () async {
                        setState(
                          () {
                            liteModeEnabled = !liteModeEnabled;
                          },
                        );
                      },
                      title: 'Lite mode: ${_enabledText(liteModeEnabled)}',
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

  String _enabledText(bool enabled) {
    return enabled ? 'on' : 'off';
  }
}

class ControlButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;

  const ControlButton({
    required this.onPressed,
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(title, textAlign: TextAlign.center),
      ),
    );
  }
}
