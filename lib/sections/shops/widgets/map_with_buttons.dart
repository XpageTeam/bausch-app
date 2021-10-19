import 'dart:async';
import 'dart:typed_data';

import 'package:bausch/models/shop/shop_model.dart';
import 'package:bausch/sections/shops/cubits/map_cubit/map_cubit.dart';
import 'package:bausch/sections/shops/listeners/map_cubit_listener.dart';
import 'package:bausch/sections/shops/widgets/bottom_sheet_content.dart';
import 'package:bausch/sections/shops/widgets/map_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
                  for (final shop in widget.shopList) {
                    if (shop.defaultPlacemark != null) {
                      (snapshot.data as YandexMapController)
                          .addPlacemark(shop.defaultPlacemark!);
                    }
                  }

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

              mapCubit.changePlacemark(
                placemark: currentPlacemark,
                isOpenning: true,
              );

              await showModalBottomSheet<dynamic>(
                barrierColor: Colors.transparent,
                context: context,
                builder: (context) => BottomSheetContent(
                  title: shop.name,
                  subtitle: shop.address,
                  phone: shop.phone,
                  btnText: 'Выбрать оптику',
                  onPressed: () {
                    // TODO(Nikolay): Кнопка.
                  },
                ),
              );

              mapCubit.changePlacemark(
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
