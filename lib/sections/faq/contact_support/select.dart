// ignore_for_file: omit_local_variable_types

import 'package:bausch/models/faq/forms/field_model.dart';
import 'package:bausch/models/faq/forms/value_model.dart';
import 'package:bausch/sections/faq/bloc/forms/fields_bloc.dart';
import 'package:bausch/sections/faq/bloc/forms_extra/forms_extra_bloc.dart';
import 'package:bausch/sections/faq/bloc/values/values_bloc.dart';
import 'package:bausch/widgets/buttons/select_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Select extends StatefulWidget {
  final String? value;
  final FieldModel model;
  //final ContactSupportScreenArguments? arguments;
  const Select({
    required this.model,
    //this.arguments,
    this.value,
    Key? key,
  }) : super(key: key);

  @override
  _SelectState createState() => _SelectState();
}

class _SelectState extends State<Select> {
  late FieldsBloc fieldsBloc;
  late FormsExtraBloc formsExtraBloc;
  late ValuesBloc valuesBloc;
  late String? _value;

  @override
  void initState() {
    super.initState();

    fieldsBloc = BlocProvider.of<FieldsBloc>(context);
    formsExtraBloc = BlocProvider.of<FormsExtraBloc>(context);
    valuesBloc = BlocProvider.of<ValuesBloc>(context);

    _value = widget.model.name;

    if (widget.model.xmlId == 'category') {
      if (fieldsBloc.state.topic != 0) {
        final ValueModel value = widget.model.values!
            .firstWhere((element) => element.id == fieldsBloc.state.topic);
        _value = value.name;
      } else {
        _value = widget.model.name;
      }
    }

    if (widget.model.xmlId == 'question') {
      if (fieldsBloc.state.question != 0) {
        final ValueModel value = widget.model.values!
            .firstWhere((element) => element.id == fieldsBloc.state.question);
        _value = value.name;
      } else {
        _value = widget.model.name;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    fieldsBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: BlocBuilder<FieldsBloc, FieldsState>(
        builder: (context, state) {
          if (widget.model.xmlId == 'question') {
            if (state.question == 0) {
              _value = widget.model.name;
            }
          }
          return SelectButton(
            value: _value ?? widget.model.name,
            color: Colors.white,
            onPressed: () {
              showCupertinoModalPopup<void>(
                context: context,
                builder: (context) => CupertinoActionSheet(
                  title: Text(widget.model.name),
                  actions: widget.model.xmlId == 'question'
                      ? valuesList(valuesBloc.state.values, context)
                      : valuesList(widget.model.values!, context),
                ),
              );
            },
          );
        },
      ),
    );
  }

  List<CupertinoActionSheetAction> valuesList(
    List<ValueModel> values,
    BuildContext _context,
  ) {
    return values
        .map(
          (e) => CupertinoActionSheetAction(
            onPressed: () {
              setState(() {
                _value = e.name;
              });

              if (widget.model.xmlId == 'category') {
                fieldsBloc
                  ..add(
                    FieldsSetTopic(e.id),
                  )
                  ..add(FieldsSetQuestion(0));

                formsExtraBloc.add(
                  FormsExtraChangeId(id: e.id),
                );
                valuesBloc.add(UpdateValues(id: e.id));
              } else if (widget.model.xmlId == 'question') {
                fieldsBloc.add(
                  FieldsSetQuestion(e.id),
                );

                formsExtraBloc.add(
                  FormsExtraChangeId(id: e.id),
                );
              } else {
                fieldsBloc.add(
                  FieldsAddExtra(
                    extra: <String, dynamic>{
                      'extra[${widget.model.xmlId}]': e.id,
                    },
                  ),
                );
              }

              Navigator.of(_context).pop();
            },
            child: Text(e.name),
          ),
        )
        .toList();
  }
}
