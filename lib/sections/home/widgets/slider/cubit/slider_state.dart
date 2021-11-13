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

@immutable
abstract class SliderState {
  final int direction;
  const SliderState({
    required this.direction,
  });
}

class SliderInitial extends SliderState {
  const SliderInitial() : super(direction: 0);
}

class SliderMoveTo extends SliderState {
  const SliderMoveTo({
    required int direction,
  }) : super(direction: direction);
}

class SliderSlideTo extends SliderState {
  const SliderSlideTo({
    required int direction,
  }) : super(
          direction: direction,
        );
}
