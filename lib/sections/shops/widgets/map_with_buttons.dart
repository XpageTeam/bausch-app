import 'dart:async';

import 'package:bausch/models/shop/shop_model.dart';
import 'package:bausch/sections/shops/cubits/map_cubit/map_cubit.dart';
import 'package:bausch/sections/shops/listeners/map_cubit_listener.dart';
import 'package:bausch/sections/shops/widgets/map_buttons.dart';
import 'package:bausch/static/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class MapWithButtons extends StatefulWidget {
  final List<ShopModel> shopList;
  const MapWithButtons({
    required this.shopList,
    Key? key,
  }) : super(key: key);

  @override
  State<MapWithButtons> createState() => _MapWithButtonsState();
}

class _MapWithButtonsState extends State<MapWithButtons> {
  final Completer<YandexMapController> mapCompleter = Completer();

  late MapCubit mapCubit;

  @override
  void initState() {
    super.initState();
    mapCubit = MapCubit(
      shopList: widget.shopList,
    );
    // TODO(Nikolay): Инициализация меток должна быть в другом месте.
    _initPlacemarks();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => mapCubit,
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xffcacecf),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(5),
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            FutureBuilder(
              future: mapCompleter.future,
              builder: (_, snapshot) {
                if (snapshot.hasData) {
                  _generatePlacemarks(
                    shopList: widget.shopList,
                    controller: snapshot.data as YandexMapController,
                  );

                  mapCubit.setCenterOnShops();
                }
                return MapCubitListener(
                  child: YandexMap(
                    onMapCreated: mapCompleter.complete,
                  ),
                  mapCompleterFuture: mapCompleter.future,
                );
              },
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 15,
                    bottom: 60,
                  ),
                  child: MapButtons(
                    onZoomIn: mapCubit.zoomIn,
                    onZoomOut: mapCubit.zoomOut,
                    onCurrentLocation: mapCubit.showCurrentLocation,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _generatePlacemarks({
    required List<ShopModel> shopList,
    required YandexMapController controller,
  }) {
    // Иначе не удаляются, либо удаляются криво
    for (var i = controller.placemarks.length - 1; i >= 0; i--) {
      if (!shopList.any((shop) => shop.placemark == controller.placemarks[i])) {
        controller.removePlacemark(controller.placemarks[i]);
      }
    }

    for (final shopModel in shopList) {
      if (shopModel.placemark != null &&
          !controller.placemarks.contains(shopModel.placemark)) {
        controller.addPlacemark(shopModel.placemark!);
      }
    }
  }

  Future<void> _initPlacemarks() async {
    final shopRawImageData =
        await Utils.getRawImageData('assets/icons/map-marker.png');

    for (final shop in widget.shopList) {
      if (shop.coords != null) {
        shop.placemark = Placemark(
          point: shop.coords!,
          onTap: (currentPlacemark, point) async {
            mapCubit.showModalBottomSheet(shopModel: shop);
          },
          style: PlacemarkStyle(
            zIndex: 1,
            opacity: 1,
            rawImageData: shopRawImageData,
          ),
        );
      }
    }
  }
}
