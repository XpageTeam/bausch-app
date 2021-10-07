import 'package:bausch/sections/order_registration/widgets/margin.dart';
import 'package:bausch/sections/order_registration/widgets/order_form_fields.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class RecipientSection extends StatelessWidget {
  const RecipientSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Margin(
      margin: const EdgeInsets.only(bottom: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Получатель',
            style: AppStyles.h1,
          ),
          SizedBox(
            height: 20,
          ),

          //* Набор полей для ввода информации о получателе
          OrderFormFields(),
        ],
      ),
    );
  }
}
