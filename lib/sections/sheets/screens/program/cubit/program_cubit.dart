import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/exceptions/success_false.dart';
import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

part 'program_state.dart';

class ProgramCubit extends Cubit<ProgramState> {
  ProgramCubit() : super(ProgramInitial());

  Future<void> loadData() async {
    final rh = RequestHandler();

    try {
      final parsedData = BaseResponseRepository.fromMap(
        (await rh.get<Map<String, dynamic>>(
          'selection/data/',
        ))
            .data!,
      );

      emit(ProgramInitial());
    } on ResponseParseException catch (e) {
      emit(ProgramInitial());
    } on DioError catch (e) {
      emit(ProgramInitial());
    } on SuccessFalse catch (e) {
      emit(ProgramInitial());
    }
  }
}
