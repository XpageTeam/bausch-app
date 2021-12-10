import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/models/sheets/base_catalog_sheet_model.dart';
import 'package:bausch/models/sheets/catalog_sheet_model.dart';
import 'package:bausch/models/sheets/catalog_sheet_with_logos.dart';
import 'package:bausch/models/sheets/catalog_sheet_without_logos_model.dart';

import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:bausch/static/static_data.dart';
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

      // final m =
      //     Map<String, dynamic>.from(parsedData.data as Map<String, dynamic>);

      //final a = (parsedData.data as Map<String, dynamic>).values.toList();

      emit(
        CatalogSheetSuccess(
          // ignore: avoid_annotating_with_dynamic
          models: (parsedData.data as List<dynamic>).map((dynamic sheet) {
            if ((sheet as Map<String, dynamic>)
                .containsValue(StaticData.types['discount_optics'])) {
              return CatalogSheetWithLogosModel.fromMap(
                sheet,
              );
            } else if (sheet.containsValue(StaticData.types['consultation'])) {
              return CatalogSheetWithoutLogosModel.fromMap(sheet);
            } else {
              return CatalogSheetModel.fromMap(sheet);
            }
          }).toList(),
        ),
      );
    } on ResponseParseException catch (sheet) {
      emit(
        CatalogSheetFailed(
          title: 'Ошибка при обработке ответа от сервера',
          subtitle: sheet.toString(),
        ),
      );
    } on DioError catch (sheet) {
      emit(
        CatalogSheetFailed(
          title: 'Ошибка при отправке запроса',
          subtitle: sheet.toString(),
        ),
      );
    }
  }
}

// data.map((dynamic sheet) {
//             if ((sheet as Map<String, dynamic>).containsKey('logos')) {
//               return CatalogSheetWithLogosModel.fromMap(
//                 sheet,
//               );
//             } else {
//               return CatalogSheetModel.fromMap(sheet);
//             }
//           }).toList(),
