import 'dart:ui';

import 'package:flutter/material.dart';

class AnimatedBlur extends AnimatedWidget {
  const AnimatedBlur({required Animation<double> animation, Key? key})
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;

    return SizedBox(
      height: animation.value,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 10,
            sigmaY: 10,
          ),
          child: Container(
            color: Colors.white.withOpacity(0.16),
          ),
        ),
      ),
    );
  }
}
