import 'package:bausch/models/sheets/folder/simple_sheet_model.dart';
import 'package:bausch/sections/sheets/sheet_methods.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/widgets/buttons/text_button.dart';
import 'package:flutter/material.dart';

class TextButtonsSection extends StatelessWidget {
  const TextButtonsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextButton(
          title: 'Правила программы',
          onPressed: () {
            showSimpleSheet(
              context,
              SimpleSheetModel(
                title: 'Частые вопросы',
                type: SimpleSheetType.rules,
              ),
            );
          },
        ),
        CustomTextButton(
          title: 'Частые вопросы',
          onPressed: () {
            showSimpleSheet(
              context,
              SimpleSheetModel(
                title: 'Частые вопросы',
                type: SimpleSheetType.faq,
              ),
            );
          },
        ),
        const CustomTextButton(title: 'Библиотека ссылок'),
      ],
    );
  }
}
