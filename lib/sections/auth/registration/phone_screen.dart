import 'package:bausch/sections/auth/registration/phone_form.dart';
import 'package:flutter/material.dart';

class PhoneScreen extends StatelessWidget {
  const PhoneScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Text(
          'Войти или создать профиль',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 24,
            height: 31 / 24,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: 100,
            bottom: 4,
          ),
          child: PhoneForm(),
        ),
      ],
    );
  }
}
