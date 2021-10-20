import 'package:bausch/widgets/buttons/normal_icon_button.dart';
import 'package:flutter/material.dart';

class SocialButtons extends StatelessWidget {
  const SocialButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, i) {
          return CircleAvatar(
            radius: 22,
            backgroundColor: Colors.white,
            child: Image.asset(
              'assets/logos/vk.png',
              height: 16,
            ),
          );
        },
        separatorBuilder: (context, i) {
          return SizedBox(
            width: 30,
          );
        },
        itemCount: 3,
      ),
    );
  }
}
