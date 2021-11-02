// ignore_for_file: avoid_annotating_with_dynamic

import 'package:after_layout/after_layout.dart';
import 'package:bausch/sections/auth/registration/bloc/login/login_bloc.dart';
import 'package:bausch/sections/auth/registration/code_screen.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/inputs/default_text_form_field.dart';
import 'package:bausch/widgets/select_widgets/custom_checkbox.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class PhoneForm extends StatefulWidget {
  const PhoneForm({Key? key}) : super(key: key);

  @override
  _PhoneFormState createState() => _PhoneFormState();
}

class _PhoneFormState extends State<PhoneForm> with AfterLayoutMixin {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isAgree = false;
  late TextEditingController controller;
  late LoginBloc loginBloc;

  @override
  void initState() {
    super.initState();

    loginBloc = BlocProvider.of<LoginBloc>(context);

    controller = MaskedTextController(
      mask: '+7 (000) 000-00-00',
      text: loginBloc.state.phone,
      afterChange: (prev, next) {
        loginBloc.add(
          LoginSetPhone(
            phone: next,
            isPhoneValid: next.length == 18,
          ),
        );

        debugPrint({
          'число символов': next.length.toString(),
        }.toString());
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    //FocusScope.of(context).unfocus();
    loginBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: formKey,
          child: DefaultTextFormField(
            labelText: 'Мобильный телефон',
            controller: controller,
            inputType: TextInputType.phone,
            textStyle: AppStyles.h1,
            onFieldSubmitted: (value) {},
            decoration: FocusScope.of(context).hasFocus
                ? const InputDecoration(
                    hintText: '+7 (900) 123-45-67',
                  )
                : null,
            inputFormatters: [
              MaskTextInputFormatter(mask: '+7 (9##) ###-##-##'),
            ],
            validator: (dynamic value) {
              if ((value! as String).isEmpty) {
                return 'Номер не введён';
              }

              if ((value! as String).length < 18) {
                return 'Введён неверный номер телефона';
              }

              return null;
            },
          ),
        ),
        BlueButtonWithText(
          text: 'Продолжить',
          onPressed: () {
            if (loginBloc.state is LoginPhoneSetted) {
              if ((loginBloc.state as LoginPhoneSetted).isPhoneValid &&
                  isAgree) {
                loginBloc.add(LoginSendPhone(phone: loginBloc.state.phone));
              }
            }
          },
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomCheckbox(
              value: isAgree,
              onChanged: (val) {
                setState(
                  () {
                    isAgree = val!;
                  },
                );
              },
            ),
            const Flexible(
              child: Text(
                'Я соглашаюсь с Условиями обработки персональных данных и Правилами программы',
                style: AppStyles.p1,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    FocusScope.of(context).unfocus();
  }
}
