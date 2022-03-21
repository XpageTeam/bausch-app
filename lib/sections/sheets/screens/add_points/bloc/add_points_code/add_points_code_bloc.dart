import 'dart:async';

import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/exceptions/success_false.dart';
import 'package:bausch/models/add_points/product_code_model.dart';
import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:meta/meta.dart';

part 'add_points_code_event.dart';
part 'add_points_code_state.dart';

class AddPointsCodeBloc extends Bloc<AddPointsCodeEvent, AddPointsCodeState> {
  AddPointsCodeBloc() : super(AddPointsCodeInitial()) {
    on<AddPointsCodeEvent>((event, emit) async {
      if (event is AddPointsCodeGet) {
        emit(AddPointsCodeLoading(
          models: state.models,
          code: state.code,
          product: state.product,
          productName: state.productName,
        ));
        emit(await loadData());
      }

      if (event is AddPointsCodeSend) {
        emit(AddPointsCodeLoading(
          models: state.models,
          code: state.code,
          product: state.product,
          productName: state.productName,
        ));
        emit(await sendCode(
          event.code,
          event.productId,
          event.productName,
        ));
      }

      if (event is AddPointsCodeUpdateCode) {
        emit(AddPointsCodeUpdated(
          models: state.models,
          code: event.code,
          product: state.product,
          productName: state.productName,
        ));
      }

      if (event is AddPointsCodeUpdateProduct) {
        emit(AddPointsCodeUpdated(
          models: state.models,
          code: state.code,
          product: event.product,
          productName: event.productName,
        ));
      }
    });

    add(AddPointsCodeGet());
  }

  Future<AddPointsCodeState> loadData() async {
    final rh = RequestHandler();

    try {
      final parsedData = BaseResponseRepository.fromMap(
        (await rh.get<Map<String, dynamic>>('/user/points/product-codes/'))
            .data!,
      );

      return AddPointsCodeGetSuccess(
        models: (parsedData.data as List<dynamic>)
            .map(
              // ignore: avoid_annotating_with_dynamic
              (dynamic code) =>
                  ProductCodeModel.fromMap(code as Map<String, dynamic>),
            )
            .toList(),
        code: state.code,
        product: state.product,
        productName: state.productName,
      );
    } on ResponseParseException catch (e) {
      return AddPointsCodeFailed(
        models: state.models,
        code: state.code,
        product: state.product,
        title: 'Ошибка при обработке ответа от сервера',
        subtitle: e.toString(),
        productName: state.productName,
      );
    } on DioError catch (e) {
      return AddPointsCodeFailed(
        models: state.models,
        code: state.code,
        product: state.product,
        title: 'Ошибка при отправке запроса',
        subtitle: e.toString(),
        productName: state.productName,
      );
    } on SuccessFalse catch (e) {
      return AddPointsCodeFailed(
        models: state.models,
        code: state.code,
        product: state.product,
        title: e.toString(),
        productName: state.productName,
      );
    }
  }

  Future<AddPointsCodeState> sendCode(
    String code,
    String productId,
    String productName,
  ) async {
    final rh = RequestHandler();

    try {
      final parsedData = BaseResponseRepository.fromMap(
        (await rh.post<Map<String, dynamic>>(
          '/user/points/add/',
          data: FormData.fromMap(
            <String, dynamic>{
              'code': code,
              'product': productId,
            },
          ),
        ))
            .data!,
      );

      unawaited(
        FirebaseAnalytics.instance.logEvent(
          name: 'add_points',
          parameters: {
            'id': productId,
            'title': productName,
          },
        ),
      );

      return AddPointsCodeSendSuccess(
        models: state.models,
        code: state.code,
        product: state.product,
        points: (parsedData.data as Map<String, dynamic>)['amount'] as int,
        productName: productName,
      );
    } on ResponseParseException catch (e) {
      return AddPointsCodeFailed(
        models: state.models,
        code: state.code,
        product: state.product,
        title: 'Ошибка при обработке ответа от сервера',
        subtitle: e.toString(),
        productName: productName,
      );
    } on DioError catch (e) {
      return AddPointsCodeFailed(
        models: state.models,
        code: state.code,
        product: state.product,
        title: 'Ошибка при отправке запроса',
        subtitle: e.toString(),
        productName: productName,
      );
    } on SuccessFalse catch (e) {
      return AddPointsCodeFailed(
        models: state.models,
        code: state.code,
        product: state.product,
        title: e.toString(),
        productName: productName,
      );
    }
  }
}