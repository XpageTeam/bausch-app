import 'package:bausch/sections/shops/cubits/map_cubit/map_cubit.dart';
import 'package:bausch/sections/shops/widgets/bottom_sheet_content.dart';
import 'package:bausch/widgets/123/default_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class MapCubitListener extends StatefulWidget {
  final Widget child;
  final Future<YandexMapController> mapCompleterFuture;

  const MapCubitListener({
    required this.child,
    required this.mapCompleterFuture,
    Key? key,
  }) : super(key: key);

  @override
  State<MapCubitListener> createState() => _MapCubitListenerState();
}

class _MapCubitListenerState extends State<MapCubitListener> {
  bool isBottomSheetOpenned = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<MapCubit, MapState>(
      listener: (context, state) async {
        final controller = await widget.mapCompleterFuture;

        //* Приближение карты
        if (state is MapZoomIn) {
          await controller.zoomIn();
        }

        //* Отдаление карты
        if (state is MapZoomOut) {
          await controller.zoomOut();
        }

        //* Ошибка
        if (state is MapFailed) {
          // if (!mounted) return;
          showDefaultNotification(
            title: state.title,
            subtitle: state.text,
          );
        }

        //* Удаление метки
        if (state is MapRemovePlacemark && state.placemark != null) {
          await controller.removePlacemark(state.placemark!);
        }

        //* Добавление метки
        if (state is MapAddPlacemark) {
          await controller.addPlacemark(state.placemark);
        }

        if (state is MapShowModalBottomSheet) {
          if (!isBottomSheetOpenned) {
            isBottomSheetOpenned = true;
            if (!mounted) {
              return;
            }
            BlocProvider.of<MapCubit>(context).changePlacemark(
              placemark: state.shopModel.placemark!,
              isOpenning: true,
            );

            await showModalBottomSheet<dynamic>(
              barrierColor: Colors.transparent,
              context: context,
              builder: (context) => BottomSheetContent(
                title: state.shopModel.name,
                subtitle: state.shopModel.address,
                phone: state.shopModel.phone,
                btnText: 'Выбрать оптику',
                onPressed: () {
                  // TODO(Nikolay): Реализовать onPressed.
                },
              ),
            );

            if (!mounted) {
              return;
            }
            BlocProvider.of<MapCubit>(context).changePlacemark(
              placemark: state.shopModel.placemark!,
              isOpenning: false,
            );
            isBottomSheetOpenned = false;
          }
        }

        //* Центрирование по всем меткам
        if (state is MapSetCenter) {
          await controller.move(
            zoom: state.zoom,
            animation: state.mapAnimation,
            point: Point(
              latitude: state.point.latitude,
              longitude: state.point.longitude,
            ),
          );
        }
      },

      //* Карта
      child: widget.child,
    );
  }
}
