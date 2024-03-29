// ignore_for_file: cascade_invocations

import 'package:bausch/models/faq/forms/field_model.dart';
import 'package:bausch/sections/faq/contact_support/wm/forms_screen_wm.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FormTextArea extends StatefulWidget {
  final FieldModel model;
  const FormTextArea({
    required this.model,
    Key? key,
  }) : super(key: key);

  @override
  _FormTextAreaState createState() => _FormTextAreaState();
}

class _FormTextAreaState extends State<FormTextArea> {
  final focusNode = FocusNode();
  late final TextEditingController controller;
  late final FormScreenWM formSreenWM;
  //late FieldsBloc fieldsBloc;

  @override
  void initState() {
    super.initState();

    formSreenWM = Provider.of<FormScreenWM>(
      context,
      listen: false,
    );
    //fieldsBloc = BlocProvider.of<FieldsBloc>(context);

    switch (widget.model.xmlId) {
      case 'comment':
        controller = formSreenWM.commentController;
        break;
      default:
        controller = TextEditingController()
          ..addListener(() {
            final map = formSreenWM.extraList.value.data!;

            map.addAll(<String, dynamic>{
              'extra[${widget.model.xmlId}]': controller.text,
            });

            formSreenWM.extraList.content(map);
          });
        break;
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: setFocus,
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 4,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              TextField(
                controller: controller,
                focusNode: focusNode,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Ваш комментарий',
                  hintStyle: AppStyles.h3,
                ),
              ),
              // IconButton(
              //   onPressed: () {
              //     Navigator.of(context).pushNamed(
              //       '/add_files',
              //       arguments: AttachFilesScreenArguments(
              //         fieldModel: widget.model,
              //         formScreenWM: formSreenWM,
              //       ),
              //     );
              //   },
              //   padding: EdgeInsets.zero,
              //   constraints: const BoxConstraints(),
              //   iconSize: 16,
              //   icon: const Icon(Icons.add_circle_outline_sharp),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  void setFocus() {
    FocusScope.of(context).requestFocus(focusNode);
  }
}
