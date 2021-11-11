import 'package:bausch/models/faq/field_model.dart';
import 'package:bausch/sections/faq/bloc/forms/fields_bloc.dart';
import 'package:bausch/sections/faq/contact_support/contact_support_screen.dart';
import 'package:bausch/sections/faq/contact_support/form_text_input.dart';
import 'package:bausch/sections/faq/contact_support/select.dart';
import 'package:bausch/widgets/inputs/default_text_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore_for_file: avoid-returning-widgets

Widget childBuilder(
  FieldModel model,
  BuildContext context, [
  ContactSupportScreenArguments? arguments,
]) {
  debugPrint(arguments?.topic?.title);
  switch (model.type) {
    case 'select':
      return Select(
        model: model,
        arguments: arguments,
      );
    case 'textarea':
      return Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: DefaultTextInput(
          labelText: model.name,
          controller: TextEditingController(),
          inputType: TextInputType.emailAddress,
          maxLines: 3,
          labelAlignment: Alignment.topLeft,
          // ignore: prefer_const_constructors
          decoration: InputDecoration(suffixIcon: Icon(Icons.add)),
        ),
      );
    default:
      return FormTextInput(model: model);
  }
}
