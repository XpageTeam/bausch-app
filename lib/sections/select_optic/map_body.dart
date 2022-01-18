import 'package:bausch/repositories/shops/shops_repository.dart';
import 'package:bausch/sections/select_optic/widget_models/map_body_wm.dart';
import 'package:bausch/sections/select_optic/widgets/bottom_sheet_content.dart';
import 'package:bausch/sections/select_optic/widgets/map_buttons.dart';
import 'package:bausch/sections/sheets/screens/discount_optics/widget_models/discount_optics_screen_wm.dart';
import 'package:bausch/widgets/123/default_notification.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:flutter/foundation.dart';

class MapBody extends CoreMwwmWidget<MapBodyWM> {
  final List<OpticShop> opticShops;

  final void Function(MapBodyWM wm) shopsEmptyCallback;
  final void Function(OpticShop shop) onOpticShopSelect;

  MapBody({
    required this.opticShops,
    required this.shopsEmptyCallback,
    required this.onOpticShopSelect,
    Key? key,
  }) : super(
          key: key,
          widgetModelBuilder: (_) => MapBodyWM(
            initOpticShops: opticShops,
          ),
        );

  @override
  WidgetState<CoreMwwmWidget<MapBodyWM>, MapBodyWM> createWidgetState() =>
      _ClusterizedMapBodyState();
}

class _ClusterizedMapBodyState extends WidgetState<MapBody, MapBodyWM> {
  late YandexMapController controller;

  @override
  void didUpdateWidget(covariant MapBody oldWidget) {
      super.didUpdateWidget(oldWidget);

    if(!listEquals(oldWidget.opticShops, widget.opticShops)){
      wm.updateMapObjects(widget.opticShops);
      wm.setCenterAction(widget.opticShops);
    }

  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      clipBehavior: Clip.hardEdge,
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(5),
      ),
      child: Stack(
        children: [
          StreamedStateBuilder<List<MapObject>>(
            streamedState: wm.mapObjectsStreamed,
            builder: (context, mapObjects) {
              return YandexMap(
                // liteModeEnabled: true,
                // mode2DEnabled: true,
                mapObjects: mapObjects,
                onMapCreated: (yandexMapController) {
                  wm
                    ..mapController = yandexMapController
                    ..setCenterAction(widget.opticShops)
                    ..onGetUserPositionError = (exception) {
                      showDefaultNotification(title: exception.title);
                    }
                    ..onPlacemarkPressed = (shop) async {
                      if (wm.isModalBottomSheetOpen.value) return;
                      await wm.isModalBottomSheetOpen.accept(true);

                      await showModalBottomSheet<void>(
                        context: context,
                        barrierColor: Colors.transparent,
                        builder: (ctx) => BottomSheetContent(
                          title: shop.title,
                          subtitle: shop.address,
                          phones: shop.phones,
                          site: shop.site,
                          // additionalInfo:
                          //     'Скидкой можно воспользоваться в любой из оптик сети.',
                          onPressed: () {
                            widget.onOpticShopSelect(shop);
                            Navigator.of(context)
                              ..pop()
                              ..pop();
                          },
                          btnText: 'Выбрать эту сеть оптик',
                        ),
                      ).whenComplete(
                        () {
                          wm
                            ..isModalBottomSheetOpen.accept(false)
                            ..updateMapObjectsWhenComplete(widget.opticShops);
                        },
                      );
                    };

                  // if (widget.opticShops.isEmpty) {
                  //   widget.shopsEmptyCallback(wm);
                  // }
                },
              );
            },
          ),
          StreamedStateBuilder<bool>(
            streamedState: wm.isModalBottomSheetOpen,
            builder: (_, isModalBottomSheetOpen) => isModalBottomSheetOpen
                ? const SizedBox()
                : Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        right: 15,
                        bottom: 60,
                      ),
                      child: MapButtons(
                        onZoomIn: wm.zoomInAction,
                        onZoomOut: wm.zoomOutAction,
                        onCurrentLocation: wm.moveToUserPosition,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  List<CityModel>? sort(List<CityModel> cities) {
    if (cities.isEmpty) return null;
    return cities..sort((a, b) => a.name.compareTo(b.name));
  }
}
