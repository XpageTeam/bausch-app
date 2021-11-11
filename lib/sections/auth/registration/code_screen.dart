import 'package:bausch/sections/auth/registration/bloc/code_resend_counter/code_resend_counter_bloc.dart';
import 'package:bausch/sections/auth/registration/bloc/login/login_bloc.dart';
import 'package:bausch/sections/auth/registration/code_form.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CodeScreen extends StatefulWidget {
  const CodeScreen({Key? key}) : super(key: key);

  @override
  State<CodeScreen> createState() => _CodeScreenState();
}

class _CodeScreenState extends State<CodeScreen> {
  late LoginBloc loginBloc;
  late String phone;

  @override
  void initState() {
    super.initState();

    loginBloc = BlocProvider.of<LoginBloc>(context);

    if (loginBloc.state is LoginPhoneSended) {
      phone = (loginBloc.state as LoginPhoneSended).phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.mystic,
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: StaticData.sidePadding,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SMS-код был отправлен\nна $phone',
              style: AppStyles.h1,
            ),
            const SizedBox(
              height: 100,
            ),
            const CodeForm(),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(
          bottom: 20,
        ),
        child: BlocBuilder<CodeResendCounterBloc, CodeResendCounterState>(
          builder: (context, state) {
            if (state is CodeResendCounterUpdated) {
              return Row(
                children: [
                  Text(
                    'Повторная отправка через 00:${state.counter}',
                    style: AppStyles.h2,
                    textAlign: TextAlign.start,
                  ),
                ],
              );
            }
            if (state is CodeResendCounterFinished) {
              return Row(
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Отправить код снова',
                      style: AppStyles.h2,
                    ),
                  ),
                ],
              );
            }
            return Container();
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
