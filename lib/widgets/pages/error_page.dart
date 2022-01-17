import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  final String title;
  final bool showAppBar;
  final String? subtitle;
  final String? buttonText;
  final VoidCallback? buttonCallback;

  const ErrorPage({
    required this.title,
    this.showAppBar = true,
    this.subtitle,
    this.buttonText,
    this.buttonCallback,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.mystic,
      appBar: showAppBar
          ? const DefaultAppBar(
              title: '',
              backgroundColor: Colors.transparent,
            )
          : null,
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: StaticData.sidePadding,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Image.asset(
                'assets/icons/error-icon.png',
                width: 120,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 30,
                bottom: 20,
              ),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppTheme.mineShaft,
                  fontWeight: FontWeight.w500,
                  fontSize: 24,
                  height: 31 / 24,
                ),
              ),
            ),
            if (subtitle != null)
              Text(
                subtitle!,
                style: AppStyles.p1Grey,
                maxLines: 5,
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
      floatingActionButton: buttonText != null
          ? Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: StaticData.sidePadding,
              ),
              child: BlueButtonWithText(
                text: buttonText!,
                onPressed: buttonCallback,
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
