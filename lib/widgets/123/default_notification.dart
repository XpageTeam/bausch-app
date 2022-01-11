import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

OverlaySupportEntry showDefaultNotification({
  required String title,
  bool success = false,
  String? subtitle,
  Duration duration = const Duration(seconds: 3),
}) {
  return showOverlayNotification(
    (c) => Material(
      borderRadius: const BorderRadius.vertical(
        bottom: Radius.circular(5),
      ),
      child: Container(
        width: double.maxFinite,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(5),
          ),
          color: AppTheme.mineShaft,
        ),
        child: _DefaultNotification(
          title: title,
          subtitle: subtitle,
          success: success,
        ),
      ),
    ),
  );
  // return showSimpleNotification(
  //   Stack(
  //     children: [
  //       // const NewEmptyAppBar(
  //       //   overlayStyle: SystemUiOverlayStyle.light,
  //       // ),
  //       _DefaultNotification(
  //         title: title,
  //         subtitle: subtitle,
  //       ),
  //     ],
  //   ),
  //   elevation: 0,
  //   contentPadding: EdgeInsets.zero,
  //   duration: duration,
  //   background: AppTheme.mineShaft,
  //   slideDismissDirection: Platform.isIOS
  //       ? DismissDirection.vertical
  //       : DismissDirection.horizontal,
  // );
}

void showTopError(CustomException ex) {
  showDefaultNotification(
    title: ex.title,
    subtitle: ex.subtitle,
  );
}

class _DefaultNotification extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool success;

  const _DefaultNotification({
    required this.title,
    required this.success,
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
          Flexible(
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (success)
                    Image.asset(
                      'assets/icons/choose.png',
                      height: 15,
                    ),
                  if (success)
                    const SizedBox(
                      width: 4,
                    ),
                  Flexible(
                    child: Text(
                      title,
                      style: AppStyles.p1White,
                      textAlign: !success ? TextAlign.left : TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (subtitle != null)
            Text(
              subtitle!,
              style: AppStyles.p1White.copyWith(
                color: Colors.white.withOpacity(0.5),
              ),
              textAlign: !success ? TextAlign.left : TextAlign.center,
            ),
        ],
      ),
    );
  }
}
