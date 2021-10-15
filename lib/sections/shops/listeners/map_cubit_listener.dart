import 'package:bausch/sections/shops/cubits/map_cubit/map_cubit.dart';
import 'package:bausch/widgets/default_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class MapCubitListener extends StatelessWidget {
  final Widget child;
  final Future<YandexMapController> mapCompleterFuture;

  const MapCubitListener({
    required this.child,
    required this.mapCompleterFuture,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<MapCubit, MapState>(
      listener: (context, state) async {
        //* Приближение карты
        if (state is MapZoomIn) {
          await (await mapCompleterFuture).zoomIn();
        }

        //* Отдаление карты
        if (state is MapZoomOut) {
          await (await mapCompleterFuture).zoomOut();
        }

        //* Ошибка
        if (state is MapFailed) {
          debugPrint('mapCubitError: ${state.title}; (${state.text}');

          // TODO(Nikolay): Найти решение получше.
          await Future<dynamic>.delayed(Duration.zero).then(
            (dynamic value) => DefaultSnackBar.show(
              context,
              title: state.title,
              text: state.text,
            ),
          );
        }

        //* Удаление метки
        if (state is MapRemovePlacemark && state.placemark != null) {
          await (await mapCompleterFuture).removePlacemark(state.placemark!);
        }

        //* Добавление метки
        if (state is MapAddPlacemark) {
          await (await mapCompleterFuture).addPlacemark(state.placemark);
        }

        //* Центрирование по всем меткам
        if (state is MapSetCenter) {
          await (await mapCompleterFuture).move(
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
      child: child,
    );
  }
}
