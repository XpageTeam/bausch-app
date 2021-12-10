import 'package:bausch/sections/faq/bloc/forms/fields_bloc.dart';
import 'package:bausch/sections/faq/cubit/forms/forms_cubit.dart';
import 'package:bausch/sections/sheets/sheet_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FormsListener extends StatelessWidget {
  final Widget child;
  const FormsListener({
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<FieldsBloc, FieldsState>(
          listener: (context, state) {
            if (state is FieldsFailed) {
              //TODO(Nikita): поменять на тот, что у Данила
              showFlushbar(state.title);
            }

            if (state is FieldsSended) {
              //TODO(Nikita): поменять на тот, что у Данила
              showFlushbar('Успех');
            }
          },
        ),
        BlocListener<FormsCubit, FormsState>(
          listener: (context, state) {
            if (state is FormsFailed) {
              //TODO(Nikita): поменять на тот, что у Данила
              showFlushbar(state.title);
              Navigator.of(context).pop();
            }
          },
        ),
      ],
      child: child,
    );
  }
}
