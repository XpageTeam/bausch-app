import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/widgets/loader/default_circle.dart';
import 'package:flutter/material.dart';

class AnimatedLoader extends StatefulWidget {
  final int duration;
  final double diameter;
  const AnimatedLoader({
    this.duration = 2200,
    this.diameter = 33,
    Key? key,
  }) : super(key: key);

  @override
  _AnimatedLoaderState createState() => _AnimatedLoaderState();
}

class _AnimatedLoaderState extends State<AnimatedLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _moveAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: widget.duration,
      ),
    )..repeat();

    _moveAnimation = TweenSequence<double>(
      [
        //* Вправо
        TweenSequenceItem(
          tween: Tween<double>(begin: 0.0, end: widget.diameter / 4).chain(
            CurveTween(
              curve: Curves.easeInOutCubic,
            ),
          ),
          weight: 15,
        ),

        //* Обратно
        TweenSequenceItem(
          tween: Tween<double>(begin: widget.diameter / 4, end: 0.0).chain(
            CurveTween(
              curve: Curves.decelerate,
            ),
          ),
          weight: 10,
        ),

        // //* Подождать
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 0.0),
          weight: 0.1,
        ),

        //* Влево
        TweenSequenceItem(
          tween: Tween<double>(begin: 0.0, end: -widget.diameter / 4).chain(
            CurveTween(
              curve: Curves.easeInOutCubic,
            ),
          ),
          weight: 15,
        ),

        //* Обратно
        TweenSequenceItem(
          tween: Tween<double>(begin: -widget.diameter / 4, end: 0.0).chain(
            CurveTween(
              curve: Curves.decelerate,
            ),
          ),
          weight: 10,
        ),

        //* Подождать
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 0.0),
          weight: 0.1,
        ),
      ],
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, _) => Transform.translate(
            offset: Offset(-_moveAnimation.value, 0),
            child: const DefaultCircle(
              color: AppTheme.sulu,
            ),
          ),
        ),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, _) => Transform.translate(
            offset: Offset(_moveAnimation.value, 0),
            child: const DefaultCircle(),
          ),
        ),
      ],
    );
  }
}
