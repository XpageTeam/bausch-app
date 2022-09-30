import 'package:bausch/sections/profile/profile_settings/lens_parameters/bloc/lens_bloc.dart';

import 'package:bausch/widgets/default_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LensListener extends StatelessWidget {
  final Widget child;
  const LensListener({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<LensBloc, LensState>(
      listener: (context, state) {
        if (state is LensFailed) {
          showDefaultNotification(
            title: state.title,
            subtitle: state.subtitle,
          );
        }

        if (state is LensSuccess) {
          showDefaultNotification(
            title: 'Параметры успешно изменены',
            success: true,
          );
          Navigator.of(context).pop();
        }
      },
      child: child,
    );
  }
}
