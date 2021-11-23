import 'package:flutter/material.dart';

class WidgetConveyor extends StatefulWidget {
  final int duration;
  final Widget child;
  const WidgetConveyor({
    required this.duration,
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  _WidgetConveyorState createState() => _WidgetConveyorState();
}

class _WidgetConveyorState extends State<WidgetConveyor>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _moveAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        seconds: widget.duration,
      ),
    )..repeat();

    _moveAnimation = Tween<double>(begin: 0.0, end: 1416).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => Transform.translate(
        offset: Offset(-_moveAnimation.value, 0),
        child: widget.child,
      ),
    );
  }
}
