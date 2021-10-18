import 'dart:async';
import 'dart:typed_data';

import 'package:bausch/models/shop/shop_model.dart';
import 'package:bausch/sections/shops/cubits/map_cubit/map_cubit.dart';
import 'package:bausch/sections/shops/listeners/map_cubit_listener.dart';
import 'package:bausch/sections/shops/widgets/map_buttons.dart';
import 'package:bausch/sections/shops/widgets/shop_info_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

@immutable
class MapWithButtons extends StatefulWidget {
  final List<ShopModel> shopList;
  late List<Placemark> placemarkList;
  MapWithButtons({
    required this.shopList,
    Key? key,
  }) : super(key: key);

  @override
  State<MapWithButtons> createState() => _MapWithButtonsState();
}

class _MapWithButtonsState extends State<MapWithButtons> {
  final Completer<YandexMapController> _mapCompleter = Completer();

  late MapCubit _mapCubit;

  @override
  void initState() {
    super.initState();
    _mapCubit = MapCubit(
      shopList: widget.shopList,
    );

    // TODO(Nikolay): Инициализация меток должна быть в другом месте.
    _initPlacemarks();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _mapCubit,
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
              future: _mapCompleter.future,
              builder: (_, snapshot) {
                if (snapshot.hasData) {
                  for (final shop in widget.shopList) {
                    if (shop.defaultPlacemark != null) {
                      (snapshot.data as YandexMapController)
                          .addPlacemark(shop.defaultPlacemark!);
                    }
                  }

                  _mapCubit.setCenterOnShops();
                }
                return MapCubitListener(
                  child: YandexMap(
                    onMapCreated: _mapCompleter.complete,
                  ),
                  mapCompleterFuture: _mapCompleter.future,
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
                    onZoomIn: _mapCubit.zoomIn,
                    onZoomOut: _mapCubit.zoomOut,
                    onCurrentLocation: _mapCubit.showCurrentLocation,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Uint8List> _getRawImageData(String imageAsset) async {
    final data = await rootBundle.load(imageAsset);
    return data.buffer.asUint8List();
  }

  Future<void> _initPlacemarks() async {
    final shopRawImageData =
        await _getRawImageData('assets/icons/map-marker.png');

    var isBottomSheetOpenned = false;

    for (final shop in widget.shopList) {
      if (shop.coords != null) {
        shop.defaultPlacemark = Placemark(
          point: shop.coords!,
          onTap: (currentPlacemark, point) async {
            if (!isBottomSheetOpenned) {
              isBottomSheetOpenned = true;

              _mapCubit.changePlacemark(
                placemark: currentPlacemark,
                isOpenning: true,
              );

              await showModalBottomSheet<dynamic>(
                barrierColor: Colors.transparent,
                context: context,
                builder: (context) => ShopInfoBottomSheet(shopModel: shop),
              );

              _mapCubit.changePlacemark(
                placemark: currentPlacemark,
                isOpenning: false,
              );

              isBottomSheetOpenned = false;
            }
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
