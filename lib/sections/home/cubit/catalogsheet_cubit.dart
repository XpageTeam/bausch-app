import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/models/sheets/base_catalog_sheet_model.dart';
import 'package:bausch/models/sheets/catalog_sheet_model.dart';
import 'package:bausch/models/sheets/catalog_sheet_with_logos.dart';

import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

part 'catalogsheet_state.dart';

class CatalogSheetCubit extends Cubit<CatalogSheetState> {
  CatalogSheetCubit() : super(CatalogSheetInitial()) {
    loadData();
  }

  Future<void> loadData() async {
    emit(CatalogSheetLoading());

    final rh = RequestHandler();

    try {
      final parsedData = BaseResponseRepository.fromMap(
        (await rh.get<Map<String, dynamic>>('catalog/sections/')).data!,
      );

      final m =
          Map<String, dynamic>.from(parsedData.data as Map<String, dynamic>);

      final a = m.values.toList();
      debugPrint(a.runtimeType.toString());

      emit(
        CatalogSheetSuccess(
          // ignore: avoid_annotating_with_dynamic
          models: a.map((dynamic e) {
            if ((e as Map<String, dynamic>).containsKey('logos')) {
              return CatalogSheetWithLogosModel.fromMap(
                e,
              );
            } else {
              return CatalogSheetModel.fromMap(e);
            }
          }).toList(),
        ),
      );
    } on ResponseParseExeption catch (e) {
      emit(
        CatalogSheetFailed(
          title: 'Ошибка при обработке ответа от сервера',
          subtitle: e.toString(),
        ),
      );
    } on DioError catch (e) {
      emit(
        CatalogSheetFailed(
          title: 'Ошибка при отправке запроса',
          subtitle: e.toString(),
        ),
      );
    }
  }
}

// data.map((dynamic e) {
//             if ((e as Map<String, dynamic>).containsKey('logos')) {
//               return CatalogSheetWithLogosModel.fromMap(
//                 e,
//               );
//             } else {
//               return CatalogSheetModel.fromMap(e);
//             }
//           }).toList(),
