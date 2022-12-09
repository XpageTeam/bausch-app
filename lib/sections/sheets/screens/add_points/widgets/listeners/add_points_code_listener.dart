import 'package:bausch/sections/sheets/screens/add_points/bloc/add_points_code/add_points_code_bloc.dart';
import 'package:bausch/widgets/default_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddPointsCodeListener extends StatelessWidget {
  const AddPointsCodeListener({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddPointsCodeBloc, AddPointsCodeState>(
      listener: (context, state) {
        if (state is AddPointsCodeFailed) {
          showDefaultNotification(title: state.title);
        }
      },
    );
  }
}
