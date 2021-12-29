import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/exceptions/success_false.dart';
import 'package:bausch/models/add_points/product_code_model.dart';
import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

part 'add_points_code_event.dart';
part 'add_points_code_state.dart';

class AddPointsCodeBloc extends Bloc<AddPointsCodeEvent, AddPointsCodeState> {
  AddPointsCodeBloc() : super(AddPointsCodeInitial()) {
    add(AddPointsCodeGet());
  }

  @override
  Stream<AddPointsCodeState> mapEventToState(
    AddPointsCodeEvent event,
  ) async* {
    if (event is AddPointsCodeGet) {
      yield AddPointsCodeLoading(
        models: state.models,
        code: state.code,
        product: state.product,
      );
      yield await loadData();
    }

    if (event is AddPointsCodeSend) {
      yield AddPointsCodeLoading(
        models: state.models,
        code: state.code,
        product: state.product,
      );
      yield await sendCode(event.code, event.productId);
    }

    if (event is AddPointsCodeUpdateCode) {
      yield AddPointsCodeUpdated(
        models: state.models,
        code: event.code,
        product: state.product,
      );
    }

    if (event is AddPointsCodeUpdateProduct) {
      yield AddPointsCodeUpdated(
        models: state.models,
        code: state.code,
        product: event.product,
      );
    }
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
      );
    } on ResponseParseException catch (e) {
      return AddPointsCodeFailed(
        models: state.models,
        code: state.code,
        product: state.product,
        title: 'Ошибка при обработке ответа от сервера',
        subtitle: e.toString(),
      );
    } on DioError catch (e) {
      return AddPointsCodeFailed(
        models: state.models,
        code: state.code,
        product: state.product,
        title: 'Ошибка при отправке запроса',
        subtitle: e.toString(),
      );
    } on SuccessFalse catch (e) {
      return AddPointsCodeFailed(
        models: state.models,
        code: state.code,
        product: state.product,
        title: e.toString(),
      );
    }
  }

  Future<AddPointsCodeState> sendCode(String code, String productId) async {
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

      return AddPointsCodeSendSuccess(
        models: state.models,
        code: state.code,
        product: state.product,
      );
    } on ResponseParseException catch (e) {
      return AddPointsCodeFailed(
        models: state.models,
        code: state.code,
        product: state.product,
        title: 'Ошибка при обработке ответа от сервера',
        subtitle: e.toString(),
      );
    } on DioError catch (e) {
      return AddPointsCodeFailed(
        models: state.models,
        code: state.code,
        product: state.product,
        title: 'Ошибка при отправке запроса',
        subtitle: e.toString(),
      );
    } on SuccessFalse catch (e) {
      return AddPointsCodeFailed(
        models: state.models,
        code: state.code,
        product: state.product,
        title: e.toString(),
      );
    }
  }
}
