import 'package:bausch/global/login/login_wm.dart';
import 'package:bausch/sections/registration/widgets/reg_screen_body.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Registration / phone_number
class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RegScreenBody(
      wm: Provider.of<LoginWM>(context),
    );
  }
}
