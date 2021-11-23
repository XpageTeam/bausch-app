import 'package:bausch/sections/auth/loading/animation_content.dart';
import 'package:bausch/sections/registration/registration_screen.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:flutter/material.dart';

class AnimatedContent extends AnimatedWidget {
  const AnimatedContent({required Animation<double> animation, Key? key})
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;

    return Container(
      transform: Matrix4.translationValues(0, animation.value, 0),
      padding: const EdgeInsets.symmetric(horizontal: StaticData.sidePadding),
      height: MediaQuery.of(context).size.height / 2,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5),
          topRight: Radius.circular(5),
        ),
      ),
      child: const AnimationContent(),
    );
  }
}
