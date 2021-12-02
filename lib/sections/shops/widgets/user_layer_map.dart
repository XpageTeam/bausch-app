import 'package:bausch/sections/shops/test_map.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class UserLayerPage extends StatelessWidget {
  const UserLayerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _UserLayerExample();
  }
}

class _UserLayerExample extends StatefulWidget {
  @override
  _UserLayerExampleState createState() => _UserLayerExampleState();
}

class _UserLayerExampleState extends State<_UserLayerExample> {
  late YandexMapController controller;

  Future<bool> get locationPermissionNotGranted async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return true;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return true;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child: YandexMap(
            onMapCreated: (YandexMapController yandexMapController) async {
              controller = yandexMapController;
            },
            onUserLocationAdded: (UserLocationView view) async {
              return view.copyWith(
                pin: view.pin.copyWith(
                  opacity: 1,
                  icon: PlacemarkIcon.single(
                    PlacemarkIconStyle(
                      image: BitmapDescriptor.fromAssetImage(
                        'assets/icons/user-marker.png',
                      ),
                    ),
                  ),
                ),
                arrow: view.arrow.copyWith(
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
            },
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    ControlButton(
                      onPressed: () async {
                        if (await locationPermissionNotGranted) {
                          _showMessage(
                            context,
                            const Text('Location permission was NOT granted'),
                          );
                          return;
                        }
                        // TODO(Nikolay): Криво работает.
                        await controller.toggleUserLayer(
                          visible: true,
                        );
                      },
                      title: 'Show user layer',
                    ),
                    ControlButton(
                      onPressed: () async {
                        if (await locationPermissionNotGranted) {
                          _showMessage(
                            context,
                            const Text('Location permission was NOT granted'),
                          );
                          return;
                        }

                        await controller.toggleUserLayer(visible: false);
                      },
                      title: 'Hide user layer',
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    ControlButton(
                      onPressed: () async {
                        if (await locationPermissionNotGranted) {
                          _showMessage(
                            context,
                            const Text('Location permission was NOT granted'),
                          );
                          return;
                        }

                        debugPrint(
                          (await controller.getUserCameraPosition())
                                  ?.toString() ??
                              'a',
                        );
                      },
                      title: 'Get user camera position',
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

  void _showMessage(BuildContext context, Text text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: text));
  }
}
