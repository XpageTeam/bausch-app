import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/models/catalog_item/catalog_item_model.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

part 'catalog_item_state.dart';

//* Получение товаров из раздела 'Бесплатная упаковка'
class CatalogItemCubit extends Cubit<CatalogItemState> {
  CatalogItemCubit() : super(CatalogItemInitial()) {
    loadData();
  }

  Future<void> loadData() async {
    emit(CatalogItemLoading());

    final rh = RequestHandler();

    try {
      final parsedData = BaseResponseRepository.fromMap(
        (await rh.get<Map<String, dynamic>>(
          'catalog/products/',
          queryParameters: <String, dynamic>{'section': 'free_product'},
        ))
            .data!,
      );

      if (parsedData.success) {
        emit(
          CatalogItemSuccess(
            items: (parsedData.data as List<dynamic>)
                .map((dynamic item) =>
                    CatalogItemModel.fromMap(item as Map<String, dynamic>))
                .toList(),
          ),
        );
      } else {
        emit(CatalogItemFailed(title: 'Ошибка при соединении'));
      }
    } on ResponseParseExeption catch (e) {
      emit(
        CatalogItemFailed(
          title: 'Ошибка при обработке ответа от сервера',
          subtitle: e.toString(),
        ),
      );
    } on DioError catch (e) {
      emit(
        CatalogItemFailed(
          title: 'Ошибка при отправке запроса',
          subtitle: e.toString(),
        ),
      );
    }
  }
}
