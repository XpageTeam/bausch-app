import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    final spaceBetween = (MediaQuery.of(context).size.width - 114.sp * 2) / 3;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      //mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          firstImg,
          height: 114.sp,
        ),
        SizedBox(
          width: spaceBetween,
        ),
        Image.asset(
          secondImg,
          height: 114.sp,
        ),
      ],
    );
  }
}
