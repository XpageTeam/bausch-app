// ignore_for_file: avoid_annotating_with_dynamic

import 'package:bausch/sections/profile/profile_settings/screens/city/city_screen.dart';
import 'package:bausch/sections/registration/screens/city_email/city_email_screen_wm.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/buttons/focus_button.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:bausch/widgets/inputs/native_text_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class CityAndEmailScreen extends CoreMwwmWidget<CityEmailScreenWM> {
  CityAndEmailScreen({
    Key? key,
  }) : super(
          widgetModelBuilder: (context) => CityEmailScreenWM(context: context),
          key: key,
        );

  @override
  WidgetState<CoreMwwmWidget<CityEmailScreenWM>, CityEmailScreenWM>
      createWidgetState() => _CityAndEmailScreenState();
}

class _CityAndEmailScreenState
    extends WidgetState<CityAndEmailScreen, CityEmailScreenWM> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.mystic,
      appBar: const DefaultAppBar(
        title: '',
        backgroundColor: AppTheme.mystic,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: StaticData.sidePadding),
        child: Form(
          // key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Text(
                  'Отлично, осталось выбрать город и указать электронную почту',
                  style: AppStyles.h1,
                ),
              ),
              StreamedStateBuilder<String?>(
                streamedState: wm.selectedCityName,
                builder: (_, cityName) {
                  return FocusButton(
                    labelText: 'Город',
                    selectedText: cityName,
                    onPressed: () async {
                      // Keys.mainNav.currentState!.pushNamed('/city');

                      // TODO: сделать через pushNamed
                      wm.setCityName(
                        await Keys.mainNav.currentState!.push<String>(
                          PageRouteBuilder<String>(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    CityScreen(),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(
                height: 4,
              ),
              Stack(
                alignment: Alignment.centerRight,
                children: [
                  NativeTextInput(
                    labelText: 'E-mail',
                    controller: wm.emailFieldController,
                    inputType: TextInputType.emailAddress,
                  ),

                  //* Кнопка с колбеком
                  if (wm.emailFieldController.text.isEmpty)
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.chevron_right_sharp,
                        color: AppTheme.grey,
                        size: 20,
                      ),
                    ),
                ],
              ),
              StreamedStateBuilder<bool>(
                streamedState: wm.codeScreenAuthTrue,
                builder: (_, state) {
                  if (!state) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 4,
                        ),
                        StreamedStateBuilder<bool>(
                          streamedState: wm.formValidationState,
                          builder: (_, state) {
                            return BlueButtonWithText(
                              text: 'Продолжить',
                              onPressed: state
                                  ? () {
                                      FocusScope.of(context).unfocus();
                                      wm.setUserDataAction();
                                    }
                                  : null,
                            );
                          },
                        ),
                      ],
                    );
                  }

                  return Column(
                    children: const [
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Мы почти у цели! На указанный E-mail отправлена ссылка, по которой необходимо перейти для подтверждения регистрации. Если письма нет, рекомендуем проверить папку «Спам».',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          height: 20 / 14,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: StreamedStateBuilder<bool>(
        streamedState: wm.codeScreenAuthTrue,
        builder: (_, state) {
          if (state) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: StaticData.sidePadding,
              ),
              child: BlueButtonWithText(
                text: 'Готово',
                onPressed: state
                    ? () {
                        Keys.mainContentNav.currentState!
                            .pushNamedAndRemoveUntil(
                          '/home',
                          (route) => false,
                        );
                      }
                    : null,
              ),
            );
          }

          return const SizedBox();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
