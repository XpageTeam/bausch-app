import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:bausch/widgets/inputs/native_text_input.dart';
import 'package:flutter/material.dart';

class EmailScreen extends StatefulWidget {
  const EmailScreen({Key? key}) : super(key: key);

  @override
  State<EmailScreen> createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar(
        title: 'Параметры линз',
        backgroundColor: AppTheme.mystic,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 30,
              bottom: 12,
            ),
            child: NativeTextInput(
              labelText: 'E-mail',
              controller: controller,
            ),
          ),
          Text(
            'Для отчёта о баллах',
            style: AppStyles.p1,
          ),
        ],
      ),
      floatingActionButton: const BlueButtonWithText(text: 'Добавить'),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
