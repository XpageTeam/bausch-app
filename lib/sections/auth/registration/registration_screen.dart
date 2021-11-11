import 'package:bausch/sections/auth/registration/bloc/login/login_bloc.dart';
import 'package:bausch/sections/auth/registration/code_screen.dart';
import 'package:bausch/sections/auth/registration/listeners/login_listeners.dart';
import 'package:bausch/sections/auth/registration/phone_screen.dart';
import 'package:bausch/sections/auth/registration/providers/login_providers.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//* Registration
//* phone number
class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final PageController pageController = PageController();
  bool isAgree = false;
  bool isNumberEnough = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.mystic,
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: StaticData.sidePadding,
        ),
        child: LoginProviders(
          child: LoginListeners(
            child: BlocBuilder<LoginBloc, LoginState>(
              builder: (context, state) {
                return PageView(
                  controller: pageController,
                  children: const [
                    PhoneScreen(),
                    CodeScreen(),
                  ],
                );
              },
            ),
            pageController: pageController,
          ),
        ),
      ),
    );
  }
}
