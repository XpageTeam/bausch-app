import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/exceptions/success_false.dart';
import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/models/catalog_item/catalog_item_model.dart';
import 'package:bausch/models/catalog_item/consultattion_item_model.dart';
import 'package:bausch/models/catalog_item/partners_item_model.dart';
import 'package:bausch/models/catalog_item/product_item_model.dart';
import 'package:bausch/models/catalog_item/promo_item_model.dart';
import 'package:bausch/models/catalog_item/webinar_item_model.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
part 'catalog_item_state.dart';

class CatalogItemCubit extends Cubit<CatalogItemState> {
  final String section;
  CatalogItemCubit({required this.section}) : super(CatalogItemInitial());

  Future<void> loadData() async {
    emit(CatalogItemLoading());

    final rh = RequestHandler();

    try {
      final parsedData = BaseResponseRepository.fromMap(
        (await rh.get<Map<String, dynamic>>(
          'catalog/products',
          queryParameters: <String, dynamic>{'section': section},
        ))
            .data!,
      );

      debugPrint(parsedData.toString());

      emit(
        CatalogItemSuccess(
          items: (parsedData.data as List<dynamic>).map(
            // ignore: avoid_annotating_with_dynamic
            (dynamic item) {
              if (section == StaticData.types['webinar']) {
                return WebinarItemModel.fromMap(item as Map<String, dynamic>);
              } else if (section == StaticData.types['consultation']) {
                return ConsultationItemModel.fromMap(
                  item as Map<String, dynamic>,
                );
              } else if (section == StaticData.types['partners']) {
                return PartnersItemModel.fromMap(
                  item as Map<String, dynamic>,
                );
                // офлайн и онлайн добавил для скидок
              } else if ((section == StaticData.types['discount_optics']) ||
                  (section == StaticData.types['discount_online']) ||
                  section.contains('online') ||
                  section.contains('offline')) {
                return PromoItemModel.fromMap(item as Map<String, dynamic>);
              } else {
                return ProductItemModel.fromMap(item as Map<String, dynamic>);
              }
            },
          ).toList(),
        ),
      );
    } on ResponseParseException catch (e) {
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
    } on SuccessFalse catch (e) {
      emit(
        CatalogItemFailed(
          title: e.toString(),
        ),
      );
    }
  }
}
