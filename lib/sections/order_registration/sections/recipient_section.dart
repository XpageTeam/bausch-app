import 'package:bausch/sections/order_registration/widget_models/order_registration_screen_wm.dart';
import 'package:bausch/sections/order_registration/widgets/order_button.dart';
import 'package:bausch/sections/order_registration/widgets/order_form_fields.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecipientSection extends StatefulWidget {
  const RecipientSection({Key? key}) : super(key: key);

  @override
  State<RecipientSection> createState() => _RecipientSectionState();
}

class _RecipientSectionState extends State<RecipientSection> {
  bool isFormShowing = false;

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
    return Container(
      margin: const EdgeInsets.only(bottom: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
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
                  text:
                      '${wm.userWM.userData.value.data!.user.name} ${wm.userWM.userData.value.data!.user.lastName}\n',
                  style: AppStyles.h2Bold,
                  children: [
                    TextSpan(
                      text:
                          '${wm.userWM.userData.value.data!.user.email}, ${wm.userWM.userData.value.data!.user.phone}',
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
