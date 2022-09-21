// ignore_for_file: avoid_catches_without_on_clauses

import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/models/my_lenses/lens_product_list_model.dart';
import 'package:bausch/models/my_lenses/lenses_pair_model.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:dio/dio.dart';

class ChooseLensesRequester {
  final _rh = RequestHandler();

  // добавляем пару линз
  // TODO(pavlov): узнать можем ли мы тут отправлять нал или пустую строку надо
  Future<BaseResponseRepository> addLensPair({
    required LensesPairModel lensesPairModel,
    required int productId,
  }) async {
    try {
      final result = await _rh.post<Map<String, dynamic>>(
        '/lenses/',
        data: FormData.fromMap(<String, dynamic>{
          'productId': productId,
          'left_eye[diopters]': lensesPairModel.left.diopters,
          'left_eye[cylinder]': lensesPairModel.left.cylinder,
          'left_eye[axis]': lensesPairModel.left.axis,
          'left_eye[addition]': lensesPairModel.left.addition,
          'right_eye[diopters]': lensesPairModel.right.diopters,
          'right_eye[cylinder]': lensesPairModel.right.cylinder,
          'right_eye[axis]': lensesPairModel.right.axis,
          'right_eye[addition]': lensesPairModel.right.addition,
        }),
      );

      final response =
          BaseResponseRepository.fromMap(result.data as Map<String, dynamic>);

      return response;
    } catch (e) {
      throw ResponseParseException('Ошибка в addLensPair: $e');
    }
  }

  // обновляем пару линз
  Future<BaseResponseRepository> updateLensPair({
    required LensesPairModel lensesPairModel,
    required int productId,
    required int pairId,
  }) async {
    try {
      final result = await _rh.post<Map<String, dynamic>>(
        '/lenses/$pairId/',
        data: FormData.fromMap(<String, dynamic>{
          'productId': productId,
          'left_eye[diopters]': lensesPairModel.left.diopters,
          'left_eye[cylinder]': lensesPairModel.left.cylinder,
          'left_eye[axis]': lensesPairModel.left.axis,
          'left_eye[addition]': lensesPairModel.left.addition,
          'right_eye[diopters]': lensesPairModel.right.diopters,
          'right_eye[cylinder]': lensesPairModel.right.cylinder,
          'right_eye[axis]': lensesPairModel.right.axis,
          'right_eye[addition]': lensesPairModel.right.addition,
        }),
      );

      final response =
          BaseResponseRepository.fromMap(result.data as Map<String, dynamic>);

      return response;
    } catch (e) {
      throw ResponseParseException('Ошибка в updateLensPair: $e');
    }
  }

// список упаковок линз
  Future<LensProductListModel> loadLensProducts() async {
    final parsedData = BaseResponseRepository.fromMap(
      (await _rh.get<Map<String, dynamic>>(
        '/lenses/products/',
      ))
          .data!,
    );
    try {
      return LensProductListModel.fromMap(parsedData.data as List<dynamic>);
    } catch (e) {
      throw ResponseParseException('Ошибка в loadLensProducts: $e');
    }
  }
}
