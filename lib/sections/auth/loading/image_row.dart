import 'package:flutter/material.dart';

class ImageRow extends StatelessWidget {
  final String firstImg;
  final String secondImg;
  const ImageRow({
    required this.firstImg,
    required this.secondImg,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      //mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          firstImg,
          height: 114,
        ),
        const SizedBox(
          width: 63,
        ),
        Image.asset(
          secondImg,
          height: 114,
        ),
      ],
    );
  }
}
