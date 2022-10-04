import 'dart:async';

import 'package:bausch/models/dadata/dadata_response_data_model.dart';
import 'package:bausch/packages/bottom_sheet/bottom_sheet.dart';
import 'package:bausch/repositories/shops/shops_repository.dart';
import 'package:bausch/sections/select_optic/widget_models/map_body_wm.dart';
import 'package:bausch/sections/select_optic/widget_models/select_optics_screen_wm.dart';
import 'package:bausch/sections/select_optic/widgets/bottom_sheet_content.dart';
import 'package:bausch/sections/select_optic/widgets/map_buttons.dart';
import 'package:bausch/sections/sheets/screens/discount_optics/widget_models/discount_optics_screen_wm.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/widgets/default_notification.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surf_mwwm/surf_mwwm.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class MapBody extends CoreMwwmWidget<MapBodyWM> {
  final List<OpticShop> opticShops;

  final void Function(MapBodyWM wm) shopsEmptyCallback;
  final void Function(OpticShop shop) onOpticShopSelect;

  final Future<void> Function(DadataResponseDataModel) onCityDefinitionCallback;

  final String selectButtonText;

  MapBody({
    required this.opticShops,
    required this.shopsEmptyCallback,
    required this.onOpticShopSelect,
    required this.selectButtonText,
    required this.onCityDefinitionCallback,
    required bool isCertificateMap,
    required OpticShop? initialOptic,
    Key? key,
  }) : super(
          key: key,
          widgetModelBuilder: (_) => MapBodyWM(
            initialOptic: initialOptic,
            initOpticShops: opticShops,
            onCityDefinitionCallback: onCityDefinitionCallback,
            isCertificateMap: isCertificateMap,
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
    if (!listEquals(oldWidget.opticShops, widget.opticShops)) {
      wm.updateMapObjects(widget.opticShops);
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
                mode2DEnabled: true,
                tiltGesturesEnabled: false,
                rotateGesturesEnabled: false,
                mapObjects: mapObjects,
                logoAlignment: const MapAlignment(
                  horizontal: HorizontalAlignment.left,
                  vertical: VerticalAlignment.bottom,
                ),
                onMapCreated: onMapCreated,
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

  Future<void> onMapCreated(YandexMapController yandexMapController) async {
    wm
      ..mapController = yandexMapController
      // ..setCenterOn(widget.opticShops)
      ..onGetUserPositionError = (exception) {
        showDefaultNotification(title: exception.title);
      }
      ..onPlacemarkPressed = (shop) async {
        if (wm.isModalBottomSheetOpen.value) return;
        await wm.isModalBottomSheetOpen.accept(true);

        unawaited(_openBottomSheet(shop));
      };

    unawaited(wm.init());
  }

  List<CityModel>? sort(List<CityModel> cities) {
    if (cities.isEmpty) return null;
    return cities..sort((a, b) => a.name.compareTo(b.name));
  }

  Future<void> _openBottomSheet(OpticShop shop) async {
    final mediaQuery = MediaQuery.of(Keys.mainNav.currentContext!);
    final screenHeight = mediaQuery.size.height;
    final maxHeight =
        (screenHeight - mediaQuery.viewPadding.top) / screenHeight;
    await showFlexibleBottomSheet<void>(
      context: context,
      minHeight: 0,
      initHeight: 0.3,
      maxHeight: maxHeight,
      anchors: [0, 0.3, maxHeight],
      isModal: false,
      builder: (ctx, controller, _) => BottomSheetContentOther(
        controller: controller,
        title: shop.title,
        subtitle: shop.address,
        phones: shop.phones,
        site: shop.site,
        features: shop is OpticShopForCertificate ? shop.features : null,
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
        context.read<SelectOpticScreenWM>().selectedOpticShop = null;

        wm
          ..isModalBottomSheetOpen.accept(false)
          ..updateMapObjectsWhenComplete(widget.opticShops);
      },
    );
  }
}
