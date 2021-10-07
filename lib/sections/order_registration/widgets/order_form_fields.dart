import 'package:bausch/sections/order_registration/widgets/blue_button.dart';
import 'package:bausch/sections/order_registration/widgets/order_textinput.dart';
import 'package:bausch/theme/styles.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';

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
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController =
      MaskedTextController(mask: '+0 000 000 00 00'); //TextEditingController();

  @override
  void initState() {
    super.initState();
    firstNameController.addListener(() {
      //  formCubit.update( Controller.value);
    });
    lastNameController.addListener(() {
      //  formCubit.update( Controller.value);
    });
    emailController.addListener(() {
      //  formCubit.update( Controller.value);
    });
    phoneController.addListener(() {
      //  formCubit.update( Controller.value);
    });
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();

    // formCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OrderTextInput(
          labelText: 'Имя',
          controller: firstNameController,
        ),
        OrderTextInput(
          labelText: 'Фамилия',
          controller: lastNameController,
        ),
        OrderTextInput(
          labelText: 'E-mail',
          controller: emailController,
          inputType: TextInputType.emailAddress,
        ),
        OrderTextInput(
          labelText: 'Мобильный телефон',
          controller: phoneController,
          inputType: TextInputType.phone,
        ),
        BlueButton(
          onPressed: widget.onPressed,
          children: const [
            Text(
              'Готово',
              style: AppStyles.h2Bold,
            ),
          ],
        ),
      ],
    );
  }
}
