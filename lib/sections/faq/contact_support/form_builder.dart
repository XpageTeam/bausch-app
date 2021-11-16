import 'package:bausch/models/faq/forms/field_model.dart';
import 'package:bausch/sections/faq/attach_files_screen.dart';
import 'package:bausch/sections/faq/bloc/forms/fields_bloc.dart';
import 'package:bausch/sections/faq/contact_support/date_picker_button.dart';
import 'package:bausch/sections/faq/contact_support/form_text_input.dart';
import 'package:bausch/sections/faq/contact_support/select.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/widgets/inputs/default_text_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore_for_file: avoid-returning-widgets

Widget childBuilder(FieldModel model, BuildContext context) {
  switch (model.type) {
    case 'select':
      return Select(
        model: model,
        //arguments: arguments,
      );
    case 'textarea':
      return FormTextInput(
        model: model,
        maxLines: 3,
        labelAlignment: Alignment.topLeft,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                '/attach',
                arguments: AttachFilesScreenArguments(
                  fieldsBloc: BlocProvider.of<FieldsBloc>(context),
                ),
              );
            },
            icon: const Icon(Icons.add_circle_outline),
          ),
        ),
      );
    case 'number':
      return FormTextInput(
        model: model,
        type: TextInputType.number,
      );
    case 'date':
      return DatePickerButton(
        model: model,
      );
    default:
      return FormTextInput(model: model);
  }
}
