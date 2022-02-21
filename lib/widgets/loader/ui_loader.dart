import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class UiCircleLoader extends StatefulWidget {
  const UiCircleLoader({Key? key}) : super(key: key);

  @override
  _UiCircleLoaderState createState() => _UiCircleLoaderState();
}

class _UiCircleLoaderState extends State<UiCircleLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late Animation<double> rotateAnimation;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: Tween(begin: 1.0, end: 0.0).animate(controller),
      child: ExtendedImage.asset(
        'assets/icons/ui-loader.png',
        width: 16,
        height: 16,
      ),
    );
  }
}
