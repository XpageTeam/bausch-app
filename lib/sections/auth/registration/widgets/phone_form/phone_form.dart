import 'package:bausch/global/login/login_wm.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/inputs/default_text_input.dart';
import 'package:bausch/widgets/select_widgets/custom_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class PhoneForm extends CoreMwwmWidget<LoginWM> {
  PhoneForm({
    required LoginWM wm,
    Key? key,
  }) : super(
          key: key,
          widgetModelBuilder: (context) => wm,
        );

  @override
  WidgetState<CoreMwwmWidget<LoginWM>, LoginWM> createWidgetState() =>
      _PhoneFormState();
}

class _PhoneFormState extends WidgetState<PhoneForm, LoginWM> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DefaultTextInput(
          labelText: 'Мобильный телефон',
          controller: wm.phoneController,
          inputType: TextInputType.phone,
          textStyle: AppStyles.h1,
          autofocus: true,
          // decoration: const InputDecoration(
          //   prefix: Text(
          //     '+7 ',
          //   ),
          // ),
          inputFormatters: [
            MaskTextInputFormatter(mask: '+7 (9##) ###-##-##'),
          ],
        ),
        StreamedStateBuilder<bool>(
          streamedState: wm.sendPhoneBtnActive,
          builder: (_, state) {
            return BlueButtonWithText(
              text: 'Продолжить',
              onPressed: state
                  ? () => wm.sendPhoneAction()
                  : null,
            );
          },
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StreamedStateBuilder<bool>(
              streamedState: wm.policyAccepted,
              builder: (_, val) {
                return CustomCheckbox(
                  value: val,
                  onChanged: (_) {
                    wm.policyAcceptAction();
                  },
                );
              },
            ),
            const Flexible(
              child: Text(
                // TODO(Danil): вывести ссылки
                'Я соглашаюсь с Условиями обработки персональных данных и Правилами программы',
                style: AppStyles.p1,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
