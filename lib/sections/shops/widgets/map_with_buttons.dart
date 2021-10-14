import 'dart:async';

import 'package:bausch/models/shop/shop_model.dart';
import 'package:bausch/sections/shops/blocs/map_bloc/map_bloc.dart';
import 'package:bausch/sections/shops/listeners/map_bloc_listener.dart';
import 'package:bausch/sections/shops/providers/map_bloc_provider.dart';
import 'package:bausch/sections/shops/widgets/map_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

@immutable
class MapWithButtons extends StatefulWidget {
  final List<ShopModel> shopList;
  const MapWithButtons({
    required this.shopList,
    Key? key,
  }) : super(key: key);

  @override
  State<MapWithButtons> createState() => _MapWithButtonsState();
}

class _MapWithButtonsState extends State<MapWithButtons>
    with AutomaticKeepAliveClientMixin<MapWithButtons> {
  final Completer<YandexMapController> _mapCompleter = Completer();

  //* wantKeepAlive нужен, чтобы сохранялось состояние этой страницы,
  //* т.к. иначе перестает работать YandexMapController
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return MapBlocProvider(
      shopList: widget.shopList,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Color(0xffcacecf),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(5),
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            MapBlocListener(
              mapBloc: BlocProvider.of<MapBloc>(context),
              mapCompleterFuture: _mapCompleter.future,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(5),
                ),
                child: YandexMap(
                  onMapRendered: () => BlocProvider.of<MapBloc>(context).add(
                    MapShowPlacemarksEvent(),
                  ),
                  onMapCreated: _onMapCreated,
                ),
              ),
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
                    onZoomIn: () async {
                      BlocProvider.of<MapBloc>(context).add(
                        MapZoomInEvent(),
                      );
                    },
                    onZoomOut: () => BlocProvider.of<MapBloc>(context).add(
                      MapZoomOutEvent(),
                    ),
                    onCurrentLocation: () =>
                        BlocProvider.of<MapBloc>(context).add(
                      MapGetCurrentLocationEvent(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///* Перехватывает [YandexMapController] и запускает в mapBloc событие [MapShowPlacemarksEvent]
  void _onMapCreated(YandexMapController controller) {
    _mapCompleter.complete(controller);
  }
}
