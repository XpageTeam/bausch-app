import 'package:flutter/material.dart';

class DelayedAnimatedTranslateOpacity extends StatelessWidget {
  final Widget child;
  final Duration delay;
  final Duration animationDuration;
  final double offsetY;
  final VoidCallback? onEnd;

  const DelayedAnimatedTranslateOpacity({
    required this.child,
    required this.offsetY,
    this.animationDuration = const Duration(milliseconds: 800),
    this.delay = const Duration(milliseconds: 200),
    this.onEnd,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: Future<bool>.delayed(
        delay,
        () => true,
      ),
      builder: (context, snapshot) {
        return AnimatedContainer(
          curve: Curves.easeOutSine,
          duration: animationDuration,
          transform: Transform.translate(
            offset: snapshot.hasData ? Offset.zero : Offset(0, offsetY),
          ).transform,
          child: AnimatedOpacity(
            curve: Curves.easeOutSine,
            duration: animationDuration ,
            opacity: snapshot.hasData ? 1 : 0,
            child: child,
          ),
        );
      },
    );
  }
}
