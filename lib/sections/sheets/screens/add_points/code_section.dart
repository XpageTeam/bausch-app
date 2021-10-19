import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/buttons/text_button_icon.dart';
import 'package:bausch/widgets/inputs/default_text_input.dart';
import 'package:flutter/material.dart';

class CodeSection extends StatefulWidget {
  const CodeSection({Key? key}) : super(key: key);

  @override
  _CodeSectionState createState() => _CodeSectionState();
}

class _CodeSectionState extends State<CodeSection> {
  TextEditingController codeController = TextEditingController();
  TextEditingController productController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 14,
        left: 12,
        right: 12,
        bottom: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          const Text(
            'Ввести код с упаковки',
            style: AppStyles.h2,
          ),
          const SizedBox(
            height: 20,
          ),
          DefaultTextInput(
            labelText: 'Код',
            controller: codeController,
            backgroundColor: AppTheme.mystic,
          ),
          const SizedBox(
            height: 4,
          ),
          DefaultTextInput(
            labelText: 'Продукт',
            controller: productController,
            backgroundColor: AppTheme.mystic,
          ),
          const SizedBox(
            height: 4,
          ),
          BlueButtonWithText(
            text: 'Добавить баллы',
            icon: const Icon(
              Icons.add,
              color: AppTheme.mineShaft,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
