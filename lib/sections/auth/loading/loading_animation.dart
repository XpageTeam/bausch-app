import 'package:bausch/sections/auth/loading/column_with_dynamic_duration.dart';
import 'package:bausch/sections/auth/loading/image_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoadingAnimation extends StatelessWidget {
  const LoadingAnimation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColumnWithDynamicDuration(
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.only(
            top: 20,
            left: 18,
            right: 18,
          ),
          child: SafeArea(
            child: Image.asset('assets/loading/logo.png'),
          ),
        ),
        const ImageRow(
          firstImg: 'assets/loading/1.png',
          secondImg: 'assets/loading/2.png',
        ),
        const ImageRow(
          firstImg: 'assets/loading/3.png',
          secondImg: 'assets/loading/4.png',
        ),
        const ImageRow(
          firstImg: 'assets/loading/5.png',
          secondImg: 'assets/loading/6.png',
        ),
      ],
    );
  }
}
