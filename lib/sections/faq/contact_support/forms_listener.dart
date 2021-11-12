import 'package:bausch/sections/faq/bloc/forms/fields_bloc.dart';
import 'package:bausch/sections/sheets/sheet_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FormsListener extends StatelessWidget {
  final Widget child;
  const FormsListener({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<FieldsBloc, FieldsState>(
          listener: (context, state) {
            if (state is FieldsFailed) {
              showFlushbar(state.title);
            }

            if (state is FieldsSended) {
              showFlushbar('Успех');
            }
          },
        ),
      ],
      child: child,
    );
  }
}
