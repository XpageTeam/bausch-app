import 'package:bausch/sections/auth/registration/bloc/code_resend_counter/code_resend_counter_bloc.dart';
import 'package:bausch/sections/auth/registration/bloc/login/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginListeners extends StatelessWidget {
  final Widget child;
  final PageController pageController;

  const LoginListeners({
    required this.child,
    required this.pageController,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            /// Переход к вводу кода из смс
            if (state is LoginPhoneSended) {
              // phoneController.

              pageController.animateToPage(
                1,
                duration: const Duration(milliseconds: 200),
                curve: Curves.ease,
              );

              BlocProvider.of<CodeResendCounterBloc>(context)
                  .add(CodeResendCounterStart());
            }
          },
        ),
      ],
      child: child,
    );
  }
}
