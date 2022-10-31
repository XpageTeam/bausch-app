import 'package:bausch/global/login/login_wm.dart';
import 'package:bausch/sections/registration/widgets/code_form/code_form.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/widgets/default_appbar.dart';
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
    final loginWM = Provider.of<LoginWM>(context);

    return Scaffold(
      backgroundColor: AppTheme.mystic,
      extendBody: true,
      appBar: const DefaultAppBar(
        title: '',
        backgroundColor: Colors.transparent,
      ),
      body: CodeForm(wm: loginWM),
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
    );
  }
}
