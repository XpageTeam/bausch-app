import 'package:bausch/sections/order_registration/widgets/order_button.dart';
import 'package:bausch/sections/order_registration/widgets/order_form_fields.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class RecipientSection extends StatefulWidget {
  const RecipientSection({Key? key}) : super(key: key);

  @override
  State<RecipientSection> createState() => _RecipientSectionState();
}

class _RecipientSectionState extends State<RecipientSection> {
  bool isFormShowing = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Получатель',
            style: AppStyles.h1,
          ),
          const SizedBox(
            height: 20,
          ),

          //* Набор полей для ввода информации о получателе
          if (isFormShowing)
            OrderFormFields(
              onPressed: () => setState(
                () {
                  isFormShowing = false;
                },
              ),
            ),

          //* Кнопка
          if (!isFormShowing)
            OrderButton(
              onPressed: () => setState(
                () {
                  isFormShowing = true;
                },
              ),
              title: Text.rich(
                TextSpan(
                  text: 'Саша Константинопольский\n',
                  style: AppStyles.h2Bold,
                  children: [
                    TextSpan(
                      text: 'sasha@mail.ru, +7 985 000 00 00',
                      style: AppStyles.p1Grey,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
