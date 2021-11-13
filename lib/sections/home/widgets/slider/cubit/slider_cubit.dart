import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'slider_state.dart';

// class SliderCubit extends Cubit<SliderState> {
//   SliderCubit() : super(const SliderInitial());

//   void movePageTo(int page) {
//     emit(
//       SliderMoveTo(
//         page: page,
//         direction: _calcDirection(page),
//       ),
//     );
//   }

//   void slidePageTo(int page) {
//     emit(
//       SliderSlideTo(
//         page: page,
//         direction: _calcDirection(page),
//       ),
//     );
//   }

// int _calcDirection(int page) {
//   if (page > state.page) {
//     if (page - state.page > 2) {
//       return -1;
//     } else {
//       return 1;
//     }
//   }
//   if (page < state.page) {
//     if (page - state.page < -2) {
//       return 1;
//     } else {
//       return -1;
//     }
//   }

//   return 0;
// }
// }

class SliderCubit extends Cubit<SliderState> {
  SliderCubit() : super(const SliderInitial());

  void movePageTo(int direction) {
    emit(
      SliderMoveTo(
        direction: direction,
      ),
    );
  }

  Future<void> slidePageTo(int direction) async {
    emit(
      SliderSlideTo(
        direction: direction,
      ),
    );
  }
}
