import 'package:bausch/sections/faq/cubit/faq/faq_cubit.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/widgets/default_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FaqListener extends StatelessWidget {
  final Widget child;
  const FaqListener({
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<FaqCubit, FaqState>(
      listener: (context, state) {
        if (state is FaqFailed) {
          Keys.mainNav.currentState!.pop();

          showDefaultNotification(
            title: state.title,
            // subtitle: state.subtitle,
          );
        }
      },
      child: child,
    );
  }
}
