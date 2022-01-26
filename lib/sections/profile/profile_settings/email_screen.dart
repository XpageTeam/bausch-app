import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/sections/profile/profile_settings/email_screen_wm.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/bottom_info_block.dart';
import 'package:bausch/widgets/buttons/floatingactionbutton.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:bausch/widgets/inputs/native_text_input.dart';
import 'package:bausch/widgets/loader/animated_loader.dart';
import 'package:bausch/widgets/loader/ui_loader.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class EmailScreen extends CoreMwwmWidget<EmailScreenWM> {
  EmailScreen({Key? key})
      : super(
          key: key,
          widgetModelBuilder: (context) => EmailScreenWM(context: context),
        );

  @override
  WidgetState<CoreMwwmWidget<EmailScreenWM>, EmailScreenWM>
      createWidgetState() => _EmailScreenState();
}

class _EmailScreenState extends WidgetState<EmailScreen, EmailScreenWM> {
  late UserWM userWM;

  bool confirmSended = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar(
        title: 'E-mail',
        backgroundColor: AppTheme.mystic,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: StaticData.sidePadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 30,
                bottom: 12,
              ),
              child: NativeTextInput(
                labelText: 'E-mail',
                controller: wm.emailController,
              ),
            ),
            StreamedStateBuilder<bool>(
              streamedState: wm.confirmSended,
              builder: (_, state) {
                return Text(
                  state
                      ? 'Мы отправили инструкцию для  подтверждения.\nПроверьте почту.'
                      : 'Для отчётов о баллах',
                  style: AppStyles.p1,
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: StreamedStateBuilder<bool>(
        streamedState: wm.isLoading,
        builder: (_, isLoading) {
          return StreamedStateBuilder<bool>(
            streamedState: wm.formValidationState,
            builder: (_, state) {
              return CustomFloatingActionButton(
                text: isLoading
                    ? ''
                    : wm.isConfirmSended
                        ? 'Готово'
                        : 'Отправить',
                withInfo: false,
                icon: isLoading ? const UiCircleLoader() : null,
                onPressed: state && !isLoading
                    ? () {
                        if (wm.isConfirmSended) {
                          wm.buttonAction();
                        } else {
                          wm.sendConfirm();
                        }
                      }
                    : null,
              );
            },
          );
        },
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          InfoBlock(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
