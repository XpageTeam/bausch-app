import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/sections/profile/profile_settings/email_sheet_wm.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/inputs/native_text_input.dart';
import 'package:bausch/widgets/loader/ui_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class EmailBottomSheet extends CoreMwwmWidget<EmailSheetWM> {
  EmailBottomSheet({Key? key})
      : super(
          key: key,
          widgetModelBuilder: (context) => EmailSheetWM(context: context),
        );

  @override
  WidgetState<CoreMwwmWidget<EmailSheetWM>, EmailSheetWM> createWidgetState() =>
      _EmailBottomSheetState();
}

class _EmailBottomSheetState
    extends WidgetState<EmailBottomSheet, EmailSheetWM> {
  late UserWM userWM;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: ColoredBox(
        color: AppTheme.mystic,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 4,
            right: StaticData.sidePadding,
            left: StaticData.sidePadding,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.mineShaft,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Изменить E-mail',
                  style: AppStyles.h1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 20,
                ),
                child: NativeTextInput(
                  labelText: 'E-mail',
                  controller: wm.emailController,
                  autofocus: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 4,
                  bottom: 40,
                ),
                child: StreamedStateBuilder<bool>(
                  streamedState: wm.isLoading,
                  builder: (_, isLoading) {
                    return StreamedStateBuilder<bool>(
                      streamedState: wm.formValidationState,
                      builder: (_, state) {
                        return BlueButtonWithText(
                          text: isLoading ? '' : 'Сохранить',
                          icon: isLoading ? const UiCircleLoader() : null,
                          onPressed: state && !isLoading
                              ? () async => wm.sendConfirm()
                              : null,
                        );
                      },
                    );
                  },
                ),
              ),
              KeyboardVisibilityBuilder(
                builder: (p0, isKeyboardVisible) {
                  if (isKeyboardVisible) {
                    return SizedBox(
                      height: MediaQuery.of(context).viewInsets.bottom,
                    );
                  }
                  return const SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
