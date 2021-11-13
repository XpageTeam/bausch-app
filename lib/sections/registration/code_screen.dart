import 'package:bausch/global/login/login_wm.dart';
import 'package:bausch/sections/registration/widgets/code_form/code_form.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CodeScreen extends StatefulWidget {
  const CodeScreen({Key? key}) : super(key: key);

  @override
  State<CodeScreen> createState() => _CodeScreenState();
}

class _CodeScreenState extends State<CodeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.mystic,
      extendBody: true,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: StaticData.sidePadding,
          ),
          child: CodeForm(
            wm: Provider.of<LoginWM>(context),
          ),
        ),
      ),
      floatingActionButton: const Padding(
        padding: EdgeInsets.only(
          bottom: 20,
        ),
        child: Text(
          'Повторная отправка через 00:20',
          style: AppStyles.p1,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

