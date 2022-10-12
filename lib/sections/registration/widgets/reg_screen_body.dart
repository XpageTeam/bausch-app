import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/global/login/login_wm.dart';
import 'package:bausch/global/login/models/login_text.dart';
import 'package:bausch/sections/registration/widgets/phone_form/phone_from.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/widgets/appbar/empty_appbar.dart';
import 'package:bausch/widgets/error_page.dart';
import 'package:bausch/widgets/loader/animated_loader.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class RegScreenBody extends CoreMwwmWidget<LoginWM> {
  RegScreenBody({
    required LoginWM wm,
    Key? key,
  }) : super(
          widgetModelBuilder: (context) => wm,
          key: key,
        );

  @override
  WidgetState<RegScreenBody, LoginWM> createWidgetState() => _RegScreenBody();
}

class _RegScreenBody extends WidgetState<RegScreenBody, LoginWM> {
  @override
  void initState() {
    super.initState();
    wm.checkBtnActive();
  }

  @override
  Widget build(BuildContext context) {
    return EntityStateBuilder<LoginText>(
      streamedState: wm.loginText,
      loadingChild: const Scaffold(
        appBar: NewEmptyAppBar(),
        body: Center(
          child: AnimatedLoader(),
        ),
      ),
      errorBuilder: (_, e) {
        final ex = e as CustomException;

        return ErrorPage(
          title: ex.title,
          subtitle: ex.subtitle,
          buttonCallback: wm.loginTextLoadAction,
          buttonText: 'Обновить',
        );
      },
      builder: (_, loginText) {
        return Scaffold(
          appBar: const NewEmptyAppBar(),
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: StaticData.sidePadding,
                ),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Войти или создать профиль',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 24,
                        height: 31 / 24,
                      ),
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                    PhoneForm(
                      wm: wm,
                      loginText: loginText,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
