part of 'slider_cubit.dart';

// @immutable
// abstract class SliderState {
//   final int page;
//   final int direction;
//   const SliderState({
//     required this.page,
//     required this.direction,
//   });
// }

// class SliderInitial extends SliderState {
//   const SliderInitial() : super(page: 2, direction: 0);
// }

// class SliderMoveTo extends SliderState {
//   const SliderMoveTo({
//     required int page,
//     required int direction,
//   }) : super(page: page, direction: direction);
// }

// class SliderSlideTo extends SliderState {
//   const SliderSlideTo({
//     required int page,
//     required int direction,
//   }) : super(
//           page: page,
//           direction: direction,
//         );
// }

// class SliderUpdate extends SliderState {
//   const SliderUpdate({required int page})
//       : super(
//           page: page,
//           direction: 0,
//         );
// }

//! Норм версия, но
// @immutable
// abstract class SliderState {
//   final int direction;
//   const SliderState({
//     required this.direction,
//   });
// }

// class SliderInitial extends SliderState {
//   const SliderInitial() : super(direction: 0);
// }

// class SliderMoveTo extends SliderState {
//   const SliderMoveTo({
//     required int direction,
//   }) : super(direction: direction);
// }

// class SliderSlideTo extends SliderState {
//   const SliderSlideTo({
//     required int direction,
//   }) : super(
//           direction: direction,
//         );
// }

//! Тоже норм, но
// @immutable
// abstract class SliderState {
//   final int page;
//   const SliderState({
//     required this.page,
//   });
// }

// class SliderInitial extends SliderState {
//   const SliderInitial({
//     required int page,
//   }) : super(
//           page: page,
//         );
// }

// class SliderMoveTo extends SliderState {
//   const SliderMoveTo({
//     required int page,
//   }) : super(
//           page: page,
//         );
// }

// class SliderSlideTo extends SliderState {
//   const SliderSlideTo({
//     required int page,
//   }) : super(
//           page: page,
//         );
// }

//! Ну и еще
// @immutable
// abstract class SliderState {
//   final int direction;
//   const SliderState({
//     required this.direction,
//   });
// }

// class SliderInitial extends SliderState {
//   const SliderInitial({
//     required int direction,
//   }) : super(
//           direction: direction,
//         );
// }

// class SliderMoveTo extends SliderState {
//   final int page;
//   const SliderMoveTo({
//     required this.page,
//     required int direction,
//   }) : super(
//           direction: direction,
//         );
// }

// class SliderSlideTo extends SliderState {
//   const SliderSlideTo({
//     required int direction,
//   }) : super(
//           direction: direction,
//         );
// }

//! И еще
@immutable
abstract class SliderState {
  final int scrollPages;
  const SliderState({
    required this.scrollPages,
  });
}

class SliderInitial extends SliderState {
  const SliderInitial({
    required int scrollPages,
  }) : super(
          scrollPages: scrollPages,
        );
}

class SliderMovePage extends SliderState {
  const SliderMovePage({
    required int scrollPages,
  }) : super(
          scrollPages: scrollPages,
        );
}

class SliderSlidePage extends SliderState {
  const SliderSlidePage({
    required int scrollPages,
  }) : super(
          scrollPages: scrollPages,
        );
}
