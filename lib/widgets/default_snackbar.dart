import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

@Deprecated('использовать showDefaultNotification вместо этого')
class DefaultSnackBar {
  static void show(
    BuildContext context, {
    required String title,
    String? text,
  }) {
    const duration = Duration(
      seconds: 2,
    );

    final snack = _makeSnackBar(
      title: title,
      text: text,
      duration: duration,
    );

    Overlay.of(context)?.insert(snack);
    Future.delayed(
      duration,
      snack.remove,
    );
  }

  static OverlayEntry _makeSnackBar({
    required String title,
    required Duration duration,
    String? text,
  }) {
    return OverlayEntry(
      builder: (_) => SnackBarContent(
        title: title,
        text: text,
        duration: duration,
      ),
    );
  }
}

class SnackBarContent extends StatefulWidget {
  final String title;
  final String? text;
  final Duration duration;
  const SnackBarContent({
    required this.title,
    required this.text,
    required this.duration,
    Key? key,
  }) : super(key: key);

  @override
  _SnackBarContentState createState() => _SnackBarContentState();
}

class _SnackBarContentState extends State<SnackBarContent>
    with SingleTickerProviderStateMixin {
  final _myKey = GlobalKey();

  late final AnimationController _controller;
  late Animation<double> _moveAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    // WidgetsBinding.instance!.addPostFrameCallback((_) {
    //   snackbarSize = getSize(_myKey);
    // });

    _moveAnimation = TweenSequence<double>(
      [
        //* Появление
        TweenSequenceItem(
          tween: Tween<double>(begin: -100, end: 0),
          weight: 1,
        ),
        // Подождать
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 0.0),
          weight: 15,
        ),

        //* Исчезновение
        TweenSequenceItem(
          tween: Tween<double>(begin: 0.0, end: -100),
          weight: 1,
        ),
      ],
    ).animate(_controller);

    _controller.forward();
  }

  // Size getSize(GlobalKey key) {
  //   final box = key.currentContext?.findRenderObject() as RenderBox;
  //   final size = box.size;
  //   return size;
  // }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => Positioned(
        left: 0,
        right: 0,
        top: _moveAnimation.value,
        child: Material(
          child: Container(
            key: _myKey,
            decoration: const BoxDecoration(
              color: AppTheme.mineShaft,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(5),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(
              StaticData.sidePadding,
              45,
              StaticData.sidePadding,
              20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.title,
                  style: AppStyles.p1White,
                ),
                if (widget.text != null)
                  Text(
                    widget.text!,
                    style: AppStyles.p1White.copyWith(
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
