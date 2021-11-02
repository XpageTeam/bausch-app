import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'code_resend_counter_event.dart';
part 'code_resend_counter_state.dart';

class CodeResendCounterBloc extends Bloc<CodeResendCounterEvent, CodeResendCounterState> {
  final int resendSeconds = 60;
  Timer? timer;

  CodeResendCounterBloc() : super(CodeResendCounterInitial());

  @override
  Future<void> close() {
    timer?.cancel();
    return super.close();
  }

  @override
  Stream<CodeResendCounterState> mapEventToState(
    CodeResendCounterEvent event,
  ) async* {
    if (event is CodeResendCounterStart){
      yield CodeResendCounterUpdated(resendSeconds);
      _startTimer();
    }

    if (event is CodeResendCounterUpdate){
      yield CodeResendCounterUpdated(event.seconds);
    }

    if (event is CodeResendCounterFinish){
      timer?.cancel();
      yield CodeResendCounterFinished();
    }
  }

  void _startTimer(){
    var secondLeft = 0;

    timer = Timer.periodic(
      const Duration(seconds: 1), 
      (_) {
        secondLeft += 1;

        if (secondLeft >= resendSeconds){
          secondLeft = 0;
          add(CodeResendCounterFinish());

          return;
        }

        add(CodeResendCounterUpdate(resendSeconds - secondLeft));
      },
    );
  }
}
