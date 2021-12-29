import 'package:bausch/sections/order_registration/widget_models/order_registration_screen_wm.dart';
import 'package:bausch/widgets/inputs/native_text_input.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderFormFields extends StatefulWidget {
  final VoidCallback? onPressed;
  const OrderFormFields({
    this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  _OrderFormFieldsState createState() => _OrderFormFieldsState();
}

class _OrderFormFieldsState extends State<OrderFormFields> {
  late OrderRegistrationScreenWM wm;

  @override
  void initState() {
    super.initState();

    wm = Provider.of<OrderRegistrationScreenWM>(
      context,
      listen: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 4),
          child: NativeTextInput(
            labelText: 'Имя',
            controller: wm.nameController,
            enabled: wm.nameFieldEnabled,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 4),
          child: NativeTextInput(
            labelText: 'Фамилия',
            controller: wm.lastNameController,
            enabled: wm.lastNameFieldEnabled,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 4),
          child: NativeTextInput(
            labelText: 'E-mail',
            controller: wm.emailController,
            inputType: TextInputType.emailAddress,
            enabled: false,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 4),
          child: NativeTextInput(
            labelText: 'Мобильный телефон',
            controller: wm.phoneController,
            inputType: TextInputType.phone,
            enabled: false,
          ),
        ),
      ],
    );
  }
}
