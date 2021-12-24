import 'dart:ui';

import 'package:bausch/models/discount_optic/discount_optic.dart';
import 'package:bausch/models/shop/shop_model.dart';
import 'package:bausch/repositories/shops/shops_repository.dart';
import 'package:bausch/sections/sheets/screens/discount_optics/widget_models/discount_optics_screen_wm.dart';
import 'package:bausch/sections/shops/map_body_wm.dart';
import 'package:bausch/sections/shops/widgets/bottom_sheet_content.dart';
import 'package:bausch/sections/shops/widgets/map_buttons.dart';
import 'package:bausch/widgets/123/default_notification.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class MapBody extends CoreMwwmWidget<MapBodyWM> {
  final List<ShopModel> shopList;
  final List<OpticShop> opticShops;

  void Function(MapBodyWM wm)? shopsEmptyCallback;

  MapBody({
    required this.shopList,
    required this.opticShops,
    this.shopsEmptyCallback,
    Key? key,
  }) : super(
          key: key,
          widgetModelBuilder: (_) => MapBodyWM(
            initShopList: shopList,
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
    wm.updateMapObjects(widget.opticShops);
    super.didUpdateWidget(oldWidget);
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
                liteModeEnabled: true,
                mode2DEnabled: true,
                mapObjects: mapObjects,
                onMapCreated: (yandexMapController) {
                  wm
                    ..mapController = yandexMapController
                    ..setCenterAction(
                      widget.opticShops
                          .where(
                            (s) => s.coords != null,
                          )
                          .toList(),
                    )
                    ..onGetUserPositionError = (exception) {
                      showDefaultNotification(title: exception.title);
                    }
                    ..onPlacemarkPressed = (shop) {
                      wm.isModalBottomSheetOpen.accept(true);

                      showModalBottomSheet<void>(
                        context: context,
                        barrierColor: Colors.transparent,
                        builder: (context) => BottomSheetContent(
                          title: shop.title,
                          subtitle: shop.address,
                          phones: shop.phones,
                          // TODO(Nikolay): Добавить сайт.
                          // site: shop.site,
                          // additionalInfo:
                          //     'Скидкой можно воспользоваться в любой из оптик сети.',
                          onPressed: Navigator.of(context).pop,
                          btnText: 'Выбрать эту сеть оптик',
                        ),
                      ).whenComplete(
                        () {
                          wm.isModalBottomSheetOpen.accept(false);
                          wm.updateMapObjects(widget.opticShops);
                        },
                      );
                    };
                  if (widget.shopList.isEmpty) {
                    widget.shopsEmptyCallback?.call(wm);
                  }
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
