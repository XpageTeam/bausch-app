import 'package:bausch/packages/pin_code_fields/lib/pin_code_fields.dart';
import 'package:bausch/sections/registration/city_and_email_screen.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:flutter/material.dart';

class CodeForm extends StatefulWidget {
  const CodeForm({Key? key}) : super(key: key);

  @override
  _CodeFormState createState() => _CodeFormState();
}

class _CodeFormState extends State<CodeForm> {
  TextEditingController codeFieldController = TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  void dispose() {
    //focusNode.dispose();
    codeFieldController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // if (!focusNode.hasFocus) {
    //   FocusScope.of(context).requestFocus(focusNode);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: PinCodeTextField(
        controller: codeFieldController,
        appContext: context,
        length: 5,
        onChanged: (str) {},
        enableActiveFill: true,
        focusNode: focusNode,
        cursorColor: AppTheme.mineShaft,
        keyboardType: TextInputType.phone,
        onCompleted: (str) {
          focusNode.unfocus();

          // TODO(Nikita): Заменить на pushNamed
          Navigator.push<void>(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const CityAndEmailScreen();
              },
            ),
          );
        },
        pinTheme: PinTheme(
          fieldHeight: 100,
          fieldWidth: 63,
          shape: PinCodeFieldShape.box,
          activeColor: Colors.white,
          borderWidth: 0,
          selectedColor: Colors.white,
          activeFillColor: Colors.white,
          selectedFillColor: Colors.white,
          inactiveFillColor: Colors.white,
          inactiveColor: Colors.white,
        ),
      ),
    );
  }
}
