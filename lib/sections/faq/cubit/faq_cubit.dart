import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/models/faq/topic_model.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

part 'faq_state.dart';

class FaqCubit extends Cubit<FaqState> {
  FaqCubit() : super(FaqInitial()) {
    loadData();
  }

  Future<void> loadData() async {
    emit(FaqLoading());

    final rh = RequestHandler();

    try {
      final parsedData = BaseResponseRepository.fromMap(
        (await rh.get<Map<String, dynamic>>('faq/')).data!,
      );

      emit(
        FaqSuccess(
          topics: (parsedData.data as List<dynamic>)
              .map((dynamic e) => TopicModel.fromMap(e as Map<String, dynamic>))
              .toList(),
        ),
      );
    } on ResponseParseExeption catch (e) {
      emit(
        FaqFailed(
          title: 'Ошибка при обработке ответа от сервера',
          subtitle: e.toString(),
        ),
      );
    } on DioError catch (e) {
      emit(
        FaqFailed(
          title: 'Ошибка при отправке запроса',
          subtitle: e.toString(),
        ),
      );
    }
  }
}
