import 'package:bausch/sections/profile/bloc/opacity_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomNotificationListener extends StatelessWidget {
  final double styleChangeValue;
  final Widget child;
  const CustomNotificationListener({
    required this.child,
    this.styleChangeValue = 0.5,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<OpacityBloc>(context);

    return NotificationListener<DraggableScrollableNotification>(
      onNotification: (notification) {
        if (notification.extent >= styleChangeValue) {
          SystemChrome.setSystemUIOverlayStyle(
            const SystemUiOverlayStyle(
              statusBarColor: Colors.white,
              statusBarIconBrightness: Brightness.dark,
            ),
          );
        } else {
          SystemChrome.setSystemUIOverlayStyle(
            const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light,
            ),
          );
        }
        bloc.add(notification.extent);
        return true;
      },
      child: child,
    );
  }
}
