import 'package:after_layout/after_layout.dart';
import 'package:bausch/models/faq/forms/field_model.dart';
import 'package:bausch/sections/faq/bloc/forms/fields_bloc.dart';
import 'package:bausch/widgets/inputs/default_text_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FormTextInput extends StatefulWidget {
  final FieldModel model;
  final TextInputType? type;
  const FormTextInput({
    required this.model,
    this.type,
    Key? key,
  }) : super(key: key);

  @override
  _FormTextInputState createState() => _FormTextInputState();
}

class _FormTextInputState extends State<FormTextInput> with AfterLayoutMixin {
  final TextEditingController controller = TextEditingController();
  late FieldsBloc fieldsBloc;

  @override
  void initState() {
    super.initState();
    fieldsBloc = BlocProvider.of<FieldsBloc>(context);
    switch (widget.model.xmlId) {
      case 'email':
        controller.addListener(
          () {
            fieldsBloc.add(
              FieldsSetEmail(controller.text),
            );
          },
        );
        break;
      default:
        controller.addListener(
          () {
            fieldsBloc.add(
              FieldsAddExtra(
                extra: controller.text.isNotEmpty
                    ? <String, dynamic>{
                        'extra[${widget.model.xmlId}]': controller.text,
                      }
                    : <String, dynamic>{},
              ),
            );
          },
        );
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: DefaultTextInput(
        labelText: widget.model.name,
        controller: controller,
        inputType: widget.type ?? TextInputType.emailAddress,
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    FocusScope.of(context).unfocus();
  }
}
