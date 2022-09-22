import 'package:bausch/models/user/user_model/subscription_model.dart';
import 'package:bausch/sections/home/widgets/containers/white_container_with_rounded_corners.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:bausch/widgets/select_widgets/custom_checkbox.dart';
import 'package:flutter/material.dart';

const notificationNames = <String, String>{
  'mobilepush': 'Из приложения',
  'email': 'По E-mail',
  'sms': 'По СМС',
};

class NotificationsSettingsScreen extends StatefulWidget {
  final List<SubscriptionModel> valuesList;
  final void Function(List<SubscriptionModel> valuesList) onSendUpdate;
  const NotificationsSettingsScreen({
    required this.valuesList,
    required this.onSendUpdate,
    Key? key,
  }) : super(key: key);

  @override
  _MyAdressesScreenState createState() => _MyAdressesScreenState();
}

class _MyAdressesScreenState extends State<NotificationsSettingsScreen> {
  late List<SubscriptionModel> currentValues;

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
                  Flexible(
                    child: Text(
                      notificationNames.entries
                          .firstWhere((element) =>
                              element.key ==
                              currentValues[0].pointOfContact.toLowerCase())
                          .value,
                      style: AppStyles.h2,
                    ),
                  ),
                  CustomCheckbox(
                    value: currentValues[0].isSubscribed,
                    onChanged: (value) {
                      currentValues[0] = SubscriptionModel(
                        pointOfContact: currentValues[0].pointOfContact,
                        isSubscribed: value!,
                        topic: currentValues[0].topic,
                      );
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
                    Flexible(
                      child: Text(
                        notificationNames.entries
                            .firstWhere((element) =>
                                element.key ==
                                currentValues[1].pointOfContact.toLowerCase())
                            .value,
                        style: AppStyles.h2,
                      ),
                    ),
                    CustomCheckbox(
                      value: currentValues[1].isSubscribed,
                      onChanged: (value) {
                        currentValues[1] = SubscriptionModel(
                          pointOfContact: currentValues[1].pointOfContact,
                          isSubscribed: value!,
                          topic: currentValues[1].topic,
                        );
                      },
                      borderRadius: 2,
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      notificationNames.entries
                          .firstWhere((element) =>
                              element.key ==
                              currentValues[2].pointOfContact.toLowerCase())
                          .value,
                      style: AppStyles.h2,
                    ),
                  ),
                  CustomCheckbox(
                    value: currentValues[2].isSubscribed,
                    onChanged: (value) {
                      currentValues[2] = SubscriptionModel(
                        pointOfContact: currentValues[2].pointOfContact,
                        isSubscribed: value!,
                        topic: currentValues[2].topic,
                      );
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
