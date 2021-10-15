import 'package:bausch/sections/profile/profile_settings/picker_screen.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/widgets/buttons/focus_button.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//* Profile/ Параметры линз
class LensesParametersScreen extends StatelessWidget {
  const LensesParametersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.mystic,
      appBar: const DefaultAppBar(
        title: 'Параметры линз',
        backgroundColor: AppTheme.mystic,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: StaticData.sidePadding),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 30,
                bottom: 4,
              ),
              child: FocusButton(
                labelText: 'Диоптрии',
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (context) {
                      return PickerScreen();
                    },
                    barrierColor: Colors.black.withOpacity(0.8),
                  );
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: FocusButton(labelText: 'Цилиндр'),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: FocusButton(labelText: 'Ось'),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: FocusButton(labelText: 'Аддидация'),
            ),
          ],
        ),
      ),
    );
  }
}
