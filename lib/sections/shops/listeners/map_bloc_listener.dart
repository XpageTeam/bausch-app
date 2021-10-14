import 'package:bausch/sections/shops/blocs/map_bloc/map_bloc.dart';
import 'package:bausch/sections/shops/widgets/shop_info_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class MapBlocListener extends StatelessWidget {
  final Widget child;
  final MapBloc mapBloc;
  final Future<YandexMapController> mapCompleterFuture;
  bool isBottomSheetOpened = false;

  MapBlocListener({
    required this.child,
    required this.mapBloc,
    required this.mapCompleterFuture,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<MapBloc, MapState>(
      bloc: mapBloc,
      listener: (context, state) async {
        //* Нанесение меток магазинов на карту
        if (state is MapShowPlacemarksState) {
          state.placemarks.forEach((await mapCompleterFuture).addPlacemark);
        }

        //* Приближение карты
        if (state is MapZoomInState) {
          await (await mapCompleterFuture).zoomIn();
        }

        //* Отдаление карты
        if (state is MapZoomOutState) {
          await (await mapCompleterFuture).zoomOut();
        }

        //* Ошибка
        if (state is MapFailedState) {
          debugPrint('MapBlocError: ${state.title}; (${state.text}');

          await Future<dynamic>.delayed(Duration.zero).then(
            (dynamic value) => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Center(
                  child: Text(
                    'Ошибка',
                  ),
                ),
              ),
            ),
          );
        }

        //* Изменение метки при выделении
        if (state is MapChangePlacemarkState) {
          await (await mapCompleterFuture).removePlacemark(state.oldPlacemark);
          await (await mapCompleterFuture).addPlacemark(state.newPlacemark);
        }

        //* Показ текущего местоположения
        if (state is MapGetCurrentLocationState) {
          if (state.oldPlacemark != null) {
            await (await mapCompleterFuture)
                .removePlacemark(state.oldPlacemark!);
          }

          await (await mapCompleterFuture).addPlacemark(state.newPlacemark);
          // ignore: cascade_invocations
          await (await mapCompleterFuture).move(
            zoom: 16,
            animation: const MapAnimation(),
            point: state.newPlacemark.point,
          );
        }

        //* Центрирование по всем меткам
        if (state is MapSetCenterState) {
          await (await mapCompleterFuture).move(
            zoom: 12,
            point: Point(
              latitude: state.centerCoords.latitude,
              longitude: state.centerCoords.longitude,
            ),
          );
        }

        //* Получение информации по магазину и открытие bottomSheet
        if (state is MapGetShopInfoState) {
          if (!isBottomSheetOpened) {
            isBottomSheetOpened = true;

            final highligtPlacemark = Placemark(
              point: state.shop.placemark!.point,
              onTap: state.shop.placemark!.onTap,
              style: PlacemarkStyle(
                scale: 2.5,
                rawImageData: state.shop.placemark!.style.rawImageData,
                zIndex: 1,
                opacity: 1,
              ),
            );

            mapBloc.add(
              MapChangePlacemarkEvent(
                newPlacemark: highligtPlacemark,
                oldPlacemark: state.shop.placemark!,
              ),
            );

            await showModalBottomSheet<dynamic>(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              context: context,
              builder: (context) {
                return ShopInfoBottomBar(
                  shopModel: state.shop,
                  onPressed: () {},
                );
              },
            );

            mapBloc.add(
              MapChangePlacemarkEvent(
                newPlacemark: state.shop.placemark!,
                oldPlacemark: highligtPlacemark,
              ),
            );

            isBottomSheetOpened = false;
          }
        }
      },

      //* Карта
      child: child,
    );
  }
}
