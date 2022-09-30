import 'package:bausch/sections/faq/bloc/forms/fields_bloc.dart';
import 'package:bausch/sections/faq/cubit/forms/forms_cubit.dart';
import 'package:bausch/widgets/default_notification.dart';
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
              showDefaultNotification(title: state.title, subtitle: state.subtitle);
            }

            if (state is FieldsSended) {
              showDefaultNotification(
                title: 'Ваше сообщение успешно отправлено!',
                success: true,
              );
              Navigator.of(context).pop();
            }
          },
        ),
        BlocListener<FormsCubit, FormsState>(
          listener: (context, state) {
            if (state is FormsFailed) {
              showDefaultNotification(title: state.title, subtitle: state.subtitle);
              Navigator.of(context).pop();
            }
          },
        ),
      ],
      child: child,
    );
  }
}
