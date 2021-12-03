import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class ProfileStatus extends StatelessWidget {
  final VoidCallback? onPressed;
  const ProfileStatus({this.onPressed, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Row(
        children: [
          const CircleAvatar(
            radius: 21,
            backgroundColor: AppTheme.turquoiseBlue,
          ),
          const SizedBox(
            width: 6,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Саша',
                    style: AppStyles.h1,
                  ),
                  // const CircleAvatar(
                  //   radius: 5,
                  //   backgroundColor: AppTheme.turquoiseBlue,
                  // ),
                  const SizedBox(
                    height: 24,
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 20,
                    ),
                  ),
                ],
              ),
              Text(
                'Классный друг',
                style: AppStyles.p1,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
