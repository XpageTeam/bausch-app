import 'package:bausch/sections/sheets/screens/add_points/bloc/add_points/add_points_bloc.dart';
import 'package:bausch/widgets/123/default_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddPointsListener extends StatelessWidget {
  const AddPointsListener({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddPointsBloc, AddPointsState>(
      listener: (context, state) {
        if (state is AddPointsFailed) {
          showDefaultNotification(title: state.title);
        }
      },
    );
  }
}
