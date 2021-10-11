import 'package:bausch/sections/registration/code_form.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

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
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: StaticData.sidePadding,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'SMS-код был отправлен\nна +7 985 000 00 00',
              style: AppStyles.h1,
            ),
            SizedBox(
              height: 100,
            ),
            CodeForm(),
          ],
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
