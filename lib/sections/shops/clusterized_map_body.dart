import 'dart:async';
import 'dart:ui';

import 'package:bausch/models/shop/shop_model.dart';
import 'package:bausch/sections/shops/clusterized_map_buttons_wm.dart';
import 'package:bausch/sections/shops/widgets/current_location_button.dart';
import 'package:bausch/sections/shops/widgets/zoom_buttons.dart';
import 'package:bausch/widgets/shop_filter_widget/bloc/shop_filter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

// class ClusterizedMapBody extends StatelessWidget {
//   final List<ShopModel> shopList;
//   const ClusterizedMapBody({
//     required this.shopList,
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return _ClusterizedPlacemarkCollectionExample();
//   }
// }

class ClusterizedMapBody extends StatefulWidget {
  final List<ShopModel> shopList;
  const ClusterizedMapBody({
    required this.shopList,
    Key? key,
  }) : super(key: key);

  @override
  _ClusterizedPlacemarkCollectionExampleState createState() =>
      _ClusterizedPlacemarkCollectionExampleState();
}

class _ClusterizedPlacemarkCollectionExampleState
    extends State<ClusterizedMapBody> {
  final Completer<YandexMapController> mapCompleter = Completer();
  List<MapObject> mapObjects = [];

  late YandexMapController controller;

  @override
  Widget build(BuildContext context) {
    debugPrint('shopList.len: ${widget.shopList.length}');
    return Stack(
      children: [
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(5),
            ),
          ),
          child: YandexMap(
            mapObjects: mapObjects,
            onMapCreated: (yandexMapController) {
              if (!mapCompleter.isCompleted) {
                mapCompleter.complete(yandexMapController);
              }
            },
          ),
        ),
        FutureBuilder<YandexMapController>(
          future: mapCompleter.future,
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              return Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 15,
                      bottom: 60,
                    ),
                    child: ClusterizedMapButtons(
                      shopList: widget.shopList,
                      mapController: snapshot.data!,
                      callback: (newMapObjects) => setState(
                        () => mapObjects = newMapObjects,
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return Container(
                color: Colors.white,
              );
            }
          },
        ),
      ],
    );
  }
}

class ClusterizedMapButtons extends CoreMwwmWidget<ClusterizedMapButtonsWM> {
  final YandexMapController mapController;
  final void Function(List<MapObject> mapObjects) callback;

  ClusterizedMapButtons({
    required this.mapController,
    required this.callback,
    required List<ShopModel> shopList,
    Key? key,
  }) : super(
          widgetModelBuilder: (context) => ClusterizedMapButtonsWM(
            mapController: mapController,
            callback: callback,
            shopList: shopList,
          ),
          key: key,
        );

  @override
  WidgetState<CoreMwwmWidget<ClusterizedMapButtonsWM>, ClusterizedMapButtonsWM>
      createWidgetState() => _ClusterizedMapButtonsState();
}

class _ClusterizedMapButtonsState
    extends WidgetState<ClusterizedMapButtons, ClusterizedMapButtonsWM> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(),
        ZoomButtons(
          zoomIn: wm.zoomInAction,
          zoomOut: wm.zoomOutAction,
        ),
        CurrentLocationButton(
          onPressed: wm.userPositionAction,
        ),
      ],
    );
  }
}
