import 'package:bausch/models/faq/forms/field_model.dart';
import 'package:bausch/sections/faq/bloc/forms/fields_bloc.dart';
import 'package:bausch/widgets/buttons/select_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DatePickerButton extends StatefulWidget {
  final FieldModel model;
  const DatePickerButton({
    required this.model,
    Key? key,
  }) : super(key: key);

  @override
  _DatePickerButtonState createState() => _DatePickerButtonState();
}

class _DatePickerButtonState extends State<DatePickerButton> {
  late FieldsBloc fieldsBloc;
  String? value;
  DateTime selectedDate = DateTime.now();

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
        value: value ?? widget.model.name,
        color: Colors.white,
        onPressed: () => selectDate(context),
      ),
    );
  }

  Future<void> selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        value = selectedDate.toString();
        fieldsBloc.add(FieldsAddExtra(extra: <String, dynamic>{
          'extra[${widget.model.xmlId}]': selectedDate.toIso8601String(),
        }));
      });
    }
  }
}