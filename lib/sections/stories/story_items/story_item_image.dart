import 'package:flutter/material.dart';

class ImageStoryItemView extends StatelessWidget {
  const ImageStoryItemView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/pic2.png',
              fit: BoxFit.cover,
            ),
          ],
        ));
  }
}
