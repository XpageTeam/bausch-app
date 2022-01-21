import 'package:bausch/models/faq/forms/field_model.dart';
import 'package:bausch/sections/faq/contact_support/wm/forms_screen_wm.dart';
import 'package:bausch/widgets/buttons/select_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
  //late FieldsBloc fieldsBloc;
  late final FormScreenWM formSreenWM;
  String? value;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    formSreenWM = Provider.of<FormScreenWM>(
      context,
      listen: false,
    );
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
    DatePicker.showDatePicker(
      context,
      initialDateTime: DateTime.now(),
      minDateTime: DateTime(1900, 8),
      maxDateTime: DateTime.now(),
      locale: DateTimePickerLocale.ru,
      onCancel: () {},
      onConfirm: (date, i) {
        if (date != selectedDate) {
          setState(() {
            selectedDate = date;
            value = DateFormat('d.M.y').format(selectedDate);

            final map = formSreenWM.extraList.value.data!;

            final newMap = <String, dynamic>{
              ...map,
              'extra[${widget.model.xmlId}]': selectedDate.toIso8601String(),
            };

            formSreenWM.extraList.content(newMap);
          });
        }
      },
    );
  }
}
