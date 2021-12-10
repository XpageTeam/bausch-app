import 'package:bausch/sections/faq/bloc/attach/attach_bloc.dart';
import 'package:bausch/sections/faq/bloc/forms/fields_bloc.dart';
import 'package:bausch/sections/faq/bloc/forms_extra/forms_extra_bloc.dart';
import 'package:bausch/sections/faq/bloc/values/values_bloc.dart';
import 'package:bausch/sections/faq/cubit/forms/forms_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FormsProvider extends StatefulWidget {
  final Widget child;
  const FormsProvider({required this.child, Key? key}) : super(key: key);

  @override
  _FormsProviderState createState() => _FormsProviderState();
}

class _FormsProviderState extends State<FormsProvider> {
  final FieldsBloc fieldsBloc = FieldsBloc();
  final ValuesBloc valuesBloc = ValuesBloc();
  final FormsExtraBloc formsExtraBloc = FormsExtraBloc();
  final FormsCubit formsCubit = FormsCubit();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => fieldsBloc),
        BlocProvider(create: (context) => formsExtraBloc),
        BlocProvider(create: (context) => formsCubit),
        BlocProvider(create: (context) => valuesBloc),
      ],
      child: widget.child,
    );
  }
}
