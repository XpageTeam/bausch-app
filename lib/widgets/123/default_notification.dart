import 'dart:io';

import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/appbar/empty_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:overlay_support/overlay_support.dart';

OverlaySupportEntry showDefaultNotification({
  required String title,
  String? subtitle,
  Duration duration = const Duration(seconds: 3),
}) {
  //TODO: Поменять на Flushbar
  return showOverlayNotification(
    (c) => Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(15),
        ),
        color: AppTheme.mineShaft,
      ),
      child: _DefaultNotification(
        title: title,
        subtitle: subtitle,
      ),
    ),
  );
  return showSimpleNotification(
    Stack(
      children: [
        // const NewEmptyAppBar(
        //   overlayStyle: SystemUiOverlayStyle.light,
        // ),
        _DefaultNotification(
          title: title,
          subtitle: subtitle,
        ),
      ],
    ),
    elevation: 0,
    contentPadding: EdgeInsets.zero,
    duration: duration,
    background: AppTheme.mineShaft,
    slideDismissDirection: Platform.isIOS
        ? DismissDirection.vertical
        : DismissDirection.horizontal,
  );
}

class _DefaultNotification extends StatelessWidget {
  final String title;
  final String? subtitle;

  const _DefaultNotification({
    required this.title,
    this.subtitle,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        // color: AppTheme.mineShaft,
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
            title,
            style: AppStyles.p1White,
          ),
          if (subtitle != null)
            Text(
              subtitle!,
              style: AppStyles.p1White.copyWith(
                color: Colors.white.withOpacity(0.5),
              ),
            ),
        ],
      ),
    );
  }
}
