import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/widgets/buttons/normal_icon_button.dart';
import 'package:flutter/material.dart';

class CurrentLocationButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CurrentLocationButton({
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NormalIconButton(
      icon: const Icon(
        Icons.location_on,
        color: AppTheme.mineShaft,
      ),
      onPressed: onPressed,
      backgroundColor: AppTheme.turquoiseBlue,
    );
  }
}