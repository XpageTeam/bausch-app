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
      yield AddPointsCodeLoading();
      yield await loadData();
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
              (dynamic code) =>
                  ProductCodeModel.fromMap(code as Map<String, dynamic>),
            )
            .toList(),
      );
    } on ResponseParseException catch (e) {
      return AddPointsCodeFailed(
        title: 'Ошибка при обработке ответа от сервера',
        subtitle: e.toString(),
      );
    } on DioError catch (e) {
      return AddPointsCodeFailed(
        title: 'Ошибка при отправке запроса',
        subtitle: e.toString(),
      );
    } on SuccessFalse catch (e) {
      return AddPointsCodeFailed(
        title: e.toString(),
      );
    }
  }
}
