// ignore_for_file: cascade_invocations

import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

OverlaySupportEntry showDefaultNotification({
  required String title,
  bool success = false,
  String? subtitle,
  Duration duration = const Duration(seconds: 2),
}) {
  return showSimpleNotification(
    Container(
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
    duration: duration,
    background: AppTheme.mineShaft,
    foreground: Colors.transparent,
    elevation: 0,
    contentPadding: EdgeInsets.zero,
    slideDismissDirection: DismissDirection.vertical,
  );
}

void showTopError(CustomException ex) {
  showDefaultNotification(
    title: ex.title,
    // subtitle: ex.subtitle,
  );
}

OverlaySupportEntry showSimpleNotification(
  Widget content, {
  /**
   * See more [ListTile.leading].
   */
  Widget? leading,
  /**
   * See more [ListTile.subtitle].
   */
  Widget? subtitle,
  /**
   * See more [ListTile.trailing].
   */
  Widget? trailing,
  /**
   * See more [ListTile.contentPadding].
   */
  EdgeInsetsGeometry? contentPadding,
  /**
   * The background color for notification, default to [ColorScheme.secondary].
   */
  Color? background,
  /**
   * See more [ListTileTheme.textColor],[ListTileTheme.iconColor].
   */
  Color? foreground,
  /**
   * The elevation of notification, see more [Material.elevation].
   */
  double elevation = 16,
  Duration? duration,
  Key? key,
  /**
   * True to auto hide after duration [kNotificationDuration].
   */
  bool autoDismiss = true,
  /**
   * Support left/right to dismiss notification.
   */
  @Deprecated('use slideDismissDirection instead') bool slideDismiss = false,
  /**
   * The position of notification, default is [NotificationPosition.top],
   */
  NotificationPosition position = NotificationPosition.top,
  BuildContext? context,
  /**
   * The direction in which the notification can be dismissed.
   */
  DismissDirection? slideDismissDirection,
}) {
  final dismissDirection = slideDismissDirection ??
      (slideDismiss ? DismissDirection.horizontal : DismissDirection.none);
  final entry = showOverlayNotification(
    (context) {
      return SlideDismissible(
        direction: dismissDirection,
        key: ValueKey(key),
        child: Material(
          color: background ?? Theme.of(context).colorScheme.secondary,
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(5),
          ),
          elevation: elevation,
          child: SafeArea(
            child: ListTileTheme(
              textColor:
                  foreground ?? Theme.of(context).colorScheme.onSecondary,
              iconColor:
                  foreground ?? Theme.of(context).colorScheme.onSecondary,
              child: ListTile(
                leading: leading,
                title: content,
                subtitle: subtitle,
                trailing: trailing,
                contentPadding: contentPadding,
              ),
            ),
          ),
        ),
      );
    },
    duration: autoDismiss ? duration : Duration.zero,
    key: key,
    position: position,
    context: context,
  );
  return entry;
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
    if (!success) {
      final appsFlyer = Provider.of<AppsflyerSdk>(context, listen: false);

      appsFlyer.logEvent('showErrorMesssage', <String, dynamic>{
        'title': title,
        if (subtitle != null) 'subtitle': subtitle,
      });
      AppMetrica.reportEventWithMap('showErrorMesssage', <String, Object>{
        'title': title,
        if (subtitle != null) 'subtitle': subtitle!,
      });
    }

    return Container(
      decoration: const BoxDecoration(
        // color: AppTheme.mineShaft,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(5),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(
        StaticData.sidePadding,
        0,
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
                      textAlign: success ? TextAlign.left : TextAlign.center,
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
              textAlign: success ? TextAlign.left : TextAlign.center,
            ),
        ],
      ),
    );
  }
}
