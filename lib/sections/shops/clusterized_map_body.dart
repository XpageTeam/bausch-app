import 'dart:async';
import 'dart:ui';

import 'package:bausch/models/shop/shop_model.dart';
import 'package:bausch/sections/shops/clusterized_map_body_wm.dart';
import 'package:bausch/sections/shops/clusterized_map_buttons_wm.dart';
import 'package:bausch/sections/shops/widgets/current_location_button.dart';
import 'package:bausch/sections/shops/widgets/zoom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class ClusterizedMapBody extends CoreMwwmWidget<ClusterizedMapBodyWM> {
  final List<ShopModel> shopList;

  ClusterizedMapBody({
    required this.shopList,
    Key? key,
  }) : super(
          key: key,
          widgetModelBuilder: (_) => ClusterizedMapBodyWM(
            initShopList: shopList,
          ),
        );

  @override
  WidgetState<CoreMwwmWidget<ClusterizedMapBodyWM>, ClusterizedMapBodyWM>
      createWidgetState() => _ClusterizedMapBodyState();
}

class _ClusterizedMapBodyState
    extends WidgetState<ClusterizedMapBody, ClusterizedMapBodyWM> {
  final Completer<YandexMapController> mapCompleter = Completer();

  late YandexMapController controller;

  @override
  void didUpdateWidget(covariant ClusterizedMapBody oldWidget) {
    wm.updateMapObjects(widget.shopList);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
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
            mapObjects: wm.mapObjectList,
            onMapCreated: (yandexMapController) {
              if (!mapCompleter.isCompleted) {
                mapCompleter.complete(yandexMapController);
                wm.setMapController(yandexMapController);
                // wm.setCenterOnShops();
              }
            },
            // onMapCreated:
            //     !mapCompleter.isCompleted ? mapCompleter.complete : null,
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
                      mapController: snapshot.data!,
                    ),
                  ),
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ],
    );
  }
}

class ClusterizedMapButtons extends CoreMwwmWidget<ClusterizedMapButtonsWM> {
  final YandexMapController mapController;

  ClusterizedMapButtons({
    required this.mapController,
    Key? key,
  }) : super(
          widgetModelBuilder: (context) => ClusterizedMapButtonsWM(
            mapController: mapController,
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
