import 'package:bausch/models/faq/forms/field_model.dart';
import 'package:bausch/models/faq/forms/value_model.dart';
import 'package:bausch/sections/faq/contact_support/wm/forms_screen_wm.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/select_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class Select extends StatefulWidget {
  final String? value;
  final FieldModel model;
  final VoidCallback? onPressed;
  //final ContactSupportScreenArguments? arguments;
  final StreamedState<ValueModel?> state;

  const Select({
    required this.model,
    required this.state,
    this.onPressed,
    //this.arguments,
    this.value,
    Key? key,
  }) : super(key: key);

  @override
  _SelectState createState() => _SelectState();
}

class _SelectState extends State<Select> {
  //late String? _value;
  late final FormScreenWM formScreenWM;

  @override
  void initState() {
    super.initState();
    formScreenWM = Provider.of<FormScreenWM>(context, listen: false);

    //_value = widget.model.name;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 4,
      ),
      child: StreamedStateBuilder<ValueModel?>(
        streamedState: widget.state,
        builder: (_, value) {
          return SelectButton(
            value: value?.name ?? widget.model.name,
            color: Colors.white,
            onPressed: () {
              showCupertinoModalPopup<void>(
                context: context,
                builder: (context) => CupertinoActionSheet(
                  title: Text(
                    widget.model.name,
                    style: AppStyles.p1,
                  ),
                  actions: valuesList(widget.model.values ?? [], context),
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
    BuildContext context,
  ) {
    return values
        .map(
          (e) => CupertinoActionSheetAction(
            onPressed: () {
              if (widget.model.xmlId == 'topic') {
                formScreenWM.loadQuestionsList(e.id);
                formScreenWM.selectedQuestion.accept(null);
              }

              if (widget.model.xmlId == 'question') {
                formScreenWM.loadExtraFields(e.id);
              }

              widget.state.accept(
                ValueModel(id: e.id, name: e.name),
              );

              Navigator.of(context).pop();
            },
            child: Text(
              e.name,
              style: AppStyles.h2,
            ),
          ),
        )
        .toList();
  }
}
