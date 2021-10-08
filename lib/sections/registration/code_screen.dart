import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

class CodeScreen extends StatefulWidget {
  const CodeScreen({Key? key}) : super(key: key);

  @override
  State<CodeScreen> createState() => _CodeScreenState();
}

class _CodeScreenState extends State<CodeScreen> {
  TextEditingController codeFieldController = TextEditingController();
  FocusNode focusNode = FocusNode();
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
          children: [
            Text(
              'SMS-код был отправлен\nна +7 985 000 00 00',
              style: AppStyles.h1,
            ),
            SizedBox(
              height: 100,
            ),
            PinCodeTextField(
              pinBoxRadius: 180,
              pinBoxBorderWidth: 0,
              defaultBorderColor: Colors.white,
              controller: codeFieldController,
              autofocus: true,
              focusNode: focusNode,
            ),
          ],
        ),
      ),
    );
  }
}
