import 'package:bausch/global/login/login_wm.dart';
import 'package:bausch/sections/registration/widgets/phone_form/phone_from.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PhoneScreen extends StatelessWidget {
  const PhoneScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Войти или создать профиль',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 24,
            height: 31 / 24,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 100,
            bottom: 4,
          ),
          child: PhoneForm(
            wm: Provider.of<LoginWM>(context),
          ),
        ),
      ],
    );
  }
}
