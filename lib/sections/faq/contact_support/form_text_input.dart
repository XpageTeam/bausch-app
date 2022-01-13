import 'package:after_layout/after_layout.dart';
import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/models/faq/forms/field_model.dart';
import 'package:bausch/sections/faq/bloc/forms/fields_bloc.dart';
import 'package:bausch/widgets/inputs/native_text_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class FormTextInput extends StatefulWidget {
  final FieldModel model;
  final TextInputType? type;
  final int? maxLines;
  final Alignment? labelAlignment;
  final InputDecoration? decoration;

  const FormTextInput({
    required this.model,
    this.type,
    this.maxLines,
    this.labelAlignment,
    this.decoration,
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

    final userWM = Provider.of<UserWM>(context, listen: false);

    switch (widget.model.xmlId) {
      case 'email':
        controller.addListener(
          () {
            fieldsBloc.add(
              FieldsSetEmail(controller.text),
            );
          },
        );

        controller.text = userWM.userData.value.data?.user.email ?? '';
        break;
      default:
        controller.addListener(
          () {
            if (controller.text.isNotEmpty) {
              fieldsBloc.add(
                FieldsAddExtra(
                  extra: <String, dynamic>{
                    'extra[${widget.model.xmlId}]': controller.text,
                  },
                ),
              );
            }

            if (controller.text.isEmpty) {
              fieldsBloc.add(
                FieldsRemoveExtra(
                  extra: <String, dynamic>{
                    'extra[${widget.model.xmlId}]': controller.text,
                  },
                ),
              );
            }
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
      child: NativeTextInput(
        labelText: widget.model.name,
        controller: controller,
        inputType: widget.type ?? TextInputType.emailAddress,
        maxLines: widget.maxLines,
        labelAlignment: widget.labelAlignment,
        decoration: widget.decoration,
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    FocusScope.of(context).unfocus();
  }
}
