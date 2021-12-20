import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/sections/order_registration/widget_models/order_registration_screen_wm.dart';
import 'package:bausch/sections/order_registration/widgets/order_button.dart';
import 'package:bausch/sections/order_registration/widgets/order_form_fields.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class RecipientSection extends StatefulWidget {
  final OrderRegistrationScreenWM wm;
  const RecipientSection({required this.wm, Key? key}) : super(key: key);

  @override
  State<RecipientSection> createState() => _RecipientSectionState();
}

class _RecipientSectionState extends State<RecipientSection> {
  bool isFormShowing = false;

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
              nameController: widget.wm.nameController,
              lastNameController: widget.wm.lastNameController,
              phoneController: widget.wm.phoneController,
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
                  text:
                      '${widget.wm.userWM.userData.value.data!.user.name} ${widget.wm.userWM.userData.value.data!.user.lastName}\n',
                  style: AppStyles.h2Bold,
                  children: [
                    TextSpan(
                      text:
                          '${widget.wm.userWM.userData.value.data!.user.email}, ${widget.wm.userWM.userData.value.data!.user.phone}',
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
