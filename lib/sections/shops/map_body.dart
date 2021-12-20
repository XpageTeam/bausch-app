import 'dart:ui';

import 'package:bausch/models/shop/shop_model.dart';
import 'package:bausch/repositories/shops/shops_repository.dart';
import 'package:bausch/sections/shops/cubits/shop_list_cubit/shoplist_cubit.dart';
import 'package:bausch/sections/shops/map_body_wm.dart';
import 'package:bausch/sections/shops/widgets/bottom_sheet_content.dart';
import 'package:bausch/sections/shops/widgets/map_buttons.dart';
import 'package:bausch/widgets/123/default_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surf_mwwm/surf_mwwm.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class MapBody extends CoreMwwmWidget<MapBodyWM> {
  final List<ShopModel> shopList;
  final List<CityModel> cityList;

  MapBody({
    required this.shopList,
    required this.cityList,
    Key? key,
  }) : super(
          key: key,
          widgetModelBuilder: (_) => MapBodyWM(initShopList: shopList),
        );

  @override
  WidgetState<CoreMwwmWidget<MapBodyWM>, MapBodyWM> createWidgetState() =>
      _ClusterizedMapBodyState();
}

class _ClusterizedMapBodyState extends WidgetState<MapBody, MapBodyWM> {
  late YandexMapController controller;

  @override
  void didUpdateWidget(covariant MapBody oldWidget) {
    wm.updateMapObjects(widget.shopList);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(5),
        ),
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
                      widget.shopList.where((s) => s.coords != null).toList(),
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
                          title: shop.name,
                          subtitle: shop.address,
                          phones: shop.phones,
                          site: shop.site,
                          // additionalInfo:
                          //     'Скидкой можно воспользоваться в любой из оптик сети.',
                          onPressed: Navigator.of(context).pop,
                          btnText: 'Выбрать эту сеть оптик',
                        ),
                      ).whenComplete(
                        () {
                          wm.isModalBottomSheetOpen.accept(false);
                          wm.updateMapObjects(widget.shopList);
                        },
                      );
                    };
                  if (widget.shopList.isEmpty) {
                    wm.isModalBottomSheetOpen.accept(true);
                    showModalBottomSheet<dynamic>(
                      barrierColor: Colors.transparent,
                      context: context,
                      builder: (context) => BottomSheetContent(
                        title: 'Поблизости нет оптик',
                        subtitle:
                            'К сожалению, в вашем городе нет подходящих оптик, но вы можете выбрать другой город.',
                        btnText: 'Хорошо',
                        onPressed: Navigator.of(context).pop,
                      ),
                    ).whenComplete(() {
                      wm.isModalBottomSheetOpen.accept(false);

                      BlocProvider.of<ShopListCubit>(context)
                        ..city = sort(widget.cityList)?[0].name ?? 'Москва'
                        ..loadShopList();
                    });
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
