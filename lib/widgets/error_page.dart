import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:flutter/material.dart';

// TODO(all): зачем нам 2 практически одинаковых экрана ошибки с одинаковым названием?
class ErrorPage extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? buttonText;
  final VoidCallback? buttonCallback;

  const ErrorPage({
    required this.title,
    this.subtitle,
    this.buttonText,
    this.buttonCallback,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.mystic,
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: StaticData.sidePadding,
          vertical: 30,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(),
            SimpleErrorWidget(
              title: title,
              subtitle: subtitle,
              buttonText: buttonText,
              buttonCallback: buttonCallback,
            ),
          ],
        ),
      ),
    );
  }
}

class SimpleErrorWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? buttonText;
  final VoidCallback? buttonCallback;

  const SimpleErrorWidget({
    required this.title,
    super.key,
    this.subtitle,
    this.buttonText,
    this.buttonCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(),
        Column(
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
                textAlign: TextAlign.center,
              ),
          ],
        ),
        if (buttonText != null)
          Padding(
            padding: const EdgeInsets.only(
              left: StaticData.sidePadding,
              right: StaticData.sidePadding,
              bottom: 10,
            ),
            child: BlueButtonWithText(
              text: buttonText!,
              onPressed: buttonCallback,
            ),
          ),
      ],
    );
  }
}
