import 'package:bausch/models/faq/forms/field_model.dart';
import 'package:bausch/sections/faq/attach_files_screen.dart';
import 'package:bausch/sections/faq/bloc/forms/fields_bloc.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  final TextEditingController controller = TextEditingController();
  late FieldsBloc fieldsBloc;

  @override
  void initState() {
    super.initState();
    fieldsBloc = BlocProvider.of<FieldsBloc>(context);

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

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Ваш комментарий',
              hintStyle: AppStyles.h3,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                '/add_files',
                arguments: AttachFilesScreenArguments(fieldsBloc: fieldsBloc),
              );
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            iconSize: 16,
            icon: const Icon(Icons.add_circle_outline_sharp),
          ),
        ],
      ),
    );
  }
}
