import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/models/sheets/catalog_sheet_model.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
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

      emit(
        CatalogSheetSuccess(
          models: (parsedData.data as List<dynamic>)
              .map((dynamic e) =>
                  CatalogSheetModel.fromMap(e as Map<String, dynamic>))
              .toList(),
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
