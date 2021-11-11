import 'package:bausch/sections/auth/registration/bloc/code_resend_counter/code_resend_counter_bloc.dart';
import 'package:bausch/sections/auth/registration/bloc/login/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginProviders extends StatefulWidget {
  final Widget child;
  const LoginProviders({required this.child, Key? key}) : super(key: key);

  @override
  _LoginProvidersState createState() => _LoginProvidersState();
}

class _LoginProvidersState extends State<LoginProviders> {
  final LoginBloc loginBloc = LoginBloc();
  final CodeResendCounterBloc codeResendCounterBloc = CodeResendCounterBloc();

  @override
  void dispose() {
    super.dispose();
    loginBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => loginBloc),
        BlocProvider(create: (context) => codeResendCounterBloc),
      ],
      child: widget.child,
    );
  }
}
