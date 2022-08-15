import 'package:bausch/sections/home/widgets/containers/white_container_with_rounded_corners.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:bausch/widgets/select_widgets/custom_checkbox.dart';
import 'package:flutter/material.dart';

class NotificationsSettingsScreen extends StatefulWidget {
  final List<bool> valuesList;
  final void Function(List<bool> valuesList) onSendUpdate;
  const NotificationsSettingsScreen({
    required this.valuesList,
    required this.onSendUpdate,
    Key? key,
  }) : super(key: key);

  @override
  _MyAdressesScreenState createState() => _MyAdressesScreenState();
}

class _MyAdressesScreenState extends State<NotificationsSettingsScreen> {
  late final List<bool> currentValues;
  @override
  void initState() {
    currentValues = [...widget.valuesList];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        title: 'Уведомления',
        backgroundColor: AppTheme.mystic,
        topRightWidget: TextButton(
          style: TextButton.styleFrom(padding: EdgeInsets.zero),
          onPressed: () => widget.onSendUpdate(currentValues),
          child: const Text(
            'Готово',
            style: AppStyles.p1,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 30,
          bottom: 80,
          left: StaticData.sidePadding,
          right: StaticData.sidePadding,
        ),
        child: WhiteContainerWithRoundedCorners(
          padding: const EdgeInsets.only(
            left: StaticData.sidePadding,
            top: 4,
            bottom: 4,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Flexible(
                    child: Text(
                      'Из приложения',
                      style: AppStyles.h2,
                    ),
                  ),
                  CustomCheckbox(
                    value: currentValues[0],
                    onChanged: (value) {
                      currentValues[0] = value!;
                    },
                    borderRadius: 2,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Flexible(
                      child: Text(
                        'По СМС',
                        style: AppStyles.h2,
                      ),
                    ),
                    CustomCheckbox(
                      value: currentValues[1],
                      onChanged: (value) {
                        currentValues[1] = value!;
                      },
                      borderRadius: 2,
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Flexible(
                    child: Text(
                      'По E-mail',
                      style: AppStyles.h2,
                    ),
                  ),
                  CustomCheckbox(
                    value: currentValues[2],
                    onChanged: (value) {
                      currentValues[2] = value!;
                    },
                    borderRadius: 2,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
