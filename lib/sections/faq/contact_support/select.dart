import 'package:bausch/models/faq/field_model.dart';
import 'package:bausch/sections/faq/bloc/forms/fields_bloc.dart';
import 'package:bausch/widgets/buttons/select_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Select extends StatefulWidget {
  final String? value;
  final FieldModel model;
  const Select({required this.model, this.value, Key? key}) : super(key: key);

  @override
  _SelectState createState() => _SelectState();
}

class _SelectState extends State<Select> {
  late FieldsBloc fieldsBloc;
  late String? _value = widget.value;

  @override
  void initState() {
    super.initState();

    fieldsBloc = BlocProvider.of<FieldsBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: SelectButton(
        value: _value ?? widget.model.name,
        color: Colors.white,
        onPressed: () {
          showCupertinoModalPopup<void>(
            context: context,
            builder: (context) => CupertinoActionSheet(
              title: Text(widget.model.name),
              actions: widget.model.values!
                  .map(
                    (e) => CupertinoActionSheetAction(
                      onPressed: () {
                        setState(() {
                          _value = e;
                        });
                        if (widget.model.xmlId == 'category') {
                          fieldsBloc.add(
                            FieldsSetTopic(widget.model.id),
                          );
                        }

                        if (widget.model.xmlId == 'question') {
                          fieldsBloc.add(
                            FieldsSetQuestion(widget.model.id),
                          );
                        }
                        Navigator.of(context).pop();
                      },
                      child: Text(e),
                    ),
                  )
                  .toList(),
            ),
          );
        },
      ),
    );
  }
}
