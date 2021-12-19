import 'dart:async';

import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/exceptions/success_false.dart';
import 'package:bausch/models/program/primary_data.dart';
import 'package:bausch/models/program/primary_data_downloader.dart';
import 'package:dio/dio.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class ProgramScreenWM extends WidgetModel {
  final primaryDataStreamed = EntityStreamedState<PrimaryData>();

  ProgramScreenWM()
      : super(
          const WidgetModelDependencies(),
        );

  @override
  void onLoad() {
    _loadData();
    super.onLoad();
  }

  Future<void> _loadData() async {
    unawaited(primaryDataStreamed.loading());

    try {
      final data = await PrimaryDataDownloader.load();

      unawaited(primaryDataStreamed.content(data));
    } on DioError catch (e) {
      unawaited(
        primaryDataStreamed.error(
          CustomException(
            title: 'Невозможно загрузить предложение',
            subtitle: e.message,
          ),
        ),
      );
    } on ResponseParseException catch (e) {
      unawaited(
        primaryDataStreamed.error(
          CustomException(
            title: 'Невозможно загрузить предложение',
            subtitle: e.toString(),
          ),
        ),
      );
    } on SuccessFalse catch (e) {
      unawaited(
        primaryDataStreamed.error(
          CustomException(
            title: 'Невозможно загрузить предложение',
            subtitle: e.toString(),
          ),
        ),
      );
    }
  }
}
