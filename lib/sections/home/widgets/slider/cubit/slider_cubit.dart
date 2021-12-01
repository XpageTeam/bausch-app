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

//! Норм версия, но
// class SliderCubit extends Cubit<SliderState> {
//   SliderCubit() : super(const SliderInitial());

//   void movePageTo(int direction) {
//     emit(
//       SliderMoveTo(
//         direction: direction,
//       ),
//     );
//   }

//   Future<void> slidePageTo(int direction) async {
//     emit(
//       SliderSlideTo(
//         direction: direction,
//       ),
//     );
//   }
// }

//! Тоже норм, но
// class SliderCubit extends Cubit<SliderState> {
//   SliderCubit({
//     required int page,
//   }) : super(
//           SliderInitial(
//             page: page,
//           ),
//         );

//   void movePageTo(int page) {
//     emit(
//       SliderMoveTo(
//         page: page,
//       ),
//     );
//   }

//   void slidePageTo(int page) {
//     emit(
//       SliderSlideTo(
//         page: page,
//       ),
//     );
//   }
// }

//! И еще
// class SliderCubit extends Cubit<SliderState> {
//   SliderCubit()
//       : super(
//           const SliderInitial(
//             direction: 0,
//           ),
//         );

//   void movePageTo(int page, int direction) {
//     emit(
//       SliderMoveTo(
//         page: page,
//         direction: direction,
//       ),
//     );
//   }

//   void slidePageTo(int direction) {
//     emit(
//       SliderSlideTo(
//         direction: direction,
//       ),
//     );
//   }
// }

//! Ну и еще
class SliderCubit extends Cubit<SliderState> {
  SliderCubit()
      : super(
          const SliderInitial(
            scrollPages: 0,
          ),
        );

  void movePageBy(int scrollPages) {
    emit(
      SliderMovePage(
        scrollPages: scrollPages,
      ),
    );
  }

  void slidePageBy(int scrollPages) {
    emit(
      SliderSlidePage(
        scrollPages: scrollPages,
      ),
    );
  }
}
