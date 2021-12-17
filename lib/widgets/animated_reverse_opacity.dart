import 'package:flutter/material.dart';

class AnimatedReverseOpacity extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration animationDuration;
  final double offsetY;
  const AnimatedReverseOpacity({
    required this.child,
    required this.offsetY,
    this.animationDuration = const Duration(milliseconds: 800),
    this.delay = const Duration(milliseconds: 200),
    Key? key,
  }) : super(key: key);

  @override
  State<AnimatedReverseOpacity> createState() => _AnimatedReverseOpacityState();
}

class _AnimatedReverseOpacityState extends State<AnimatedReverseOpacity>
    with TickerProviderStateMixin {
  late Animation animation;
  late AnimationController controller;
  bool delayCompleted = false;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    animation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeOutSine,
      ),
    );

    controller.addListener(() {
      if (controller.isCompleted) {
        controller.reverse();
      }
    });

    Future.delayed(
      widget.delay,
      () {
        controller.forward();
        setState(() {
          delayCompleted = true;
        });
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      curve: Curves.easeOutSine,
      duration: widget.animationDuration,
      transform: Transform.translate(
        offset: delayCompleted ? Offset.zero : Offset(0, widget.offsetY),
      ).transform,
      child: FadeTransition(
        opacity: controller.drive(
          CurveTween(curve: Curves.easeOutSine),
        ),
        child: widget.child,
      ),
    );
  }
}
