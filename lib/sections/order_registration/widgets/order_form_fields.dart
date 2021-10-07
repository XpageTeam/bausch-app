import 'package:bausch/sections/order_registration/widgets/order_textinput.dart';
import 'package:flutter/material.dart';

class OrderFormFields extends StatefulWidget {
  const OrderFormFields({Key? key}) : super(key: key);

  @override
  _OrderFormFieldsState createState() => _OrderFormFieldsState();
}

class _OrderFormFieldsState extends State<OrderFormFields> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

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
      children: const [
        OrderTextInput(label: 'Имя'),
        OrderTextInput(label: 'Фамилия'),
        OrderTextInput(label: 'E-mail'),
        OrderTextInput(label: 'Мобильный телефон'),
      ],
    );
  }
}
