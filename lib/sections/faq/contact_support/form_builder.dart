import 'package:bausch/models/faq/forms/field_model.dart';
import 'package:bausch/sections/faq/contact_support/widgets/date_picker_button.dart';
import 'package:bausch/sections/faq/contact_support/widgets/file_select.dart';
import 'package:bausch/sections/faq/contact_support/widgets/form_text_area.dart';
import 'package:bausch/sections/faq/contact_support/widgets/form_text_input.dart';
import 'package:flutter/material.dart';

// ignore_for_file: avoid-returning-widgets

Widget childBuilder(FieldModel model, BuildContext context) {
  debugPrint('тип поля: ${model.type}');
  switch (model.type) {
    //   case 'select':
    //     return Select(
    //       model: model,
    //       //arguments: arguments,
    //     );
    case 'textarea':
      return FormTextArea(model: model);
    // case 'number':
    //   return FormTextInput(
    //     model: model,
    //     type: TextInputType.number,
    //   );
    case 'date':
      return DatePickerButton(
        model: model,
      );
    case 'file':
      return FileSelect(
        model: model,
      );

    case 'number':
      return FormTextInput(
        model: model,
        type: TextInputType.number,
      );
    case 'string':

    default:
      return FormTextInput(model: model);
  }
}
