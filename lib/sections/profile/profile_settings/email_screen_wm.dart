import 'package:bausch/global/user/user_wm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class EmailScreenWM extends WidgetModel {
  final BuildContext context;

  final emailController = TextEditingController();

  EmailScreenWM({required this.context})
      : super(const WidgetModelDependencies());

  @override
  void onBind() {
    final userWM = Provider.of<UserWM>(context, listen: false);

    emailController.text = userWM.userData.value.data!.user.email ?? '';

    super.onBind();
  }

  @override
  void dispose() {
    super.dispose();

    emailController.dispose();
  }

  Future<void> sendUserData() async {
    final userWM = Provider.of<UserWM>(context, listen: false);

    debugPrint(userWM.toString());

    await userWM.updateUserData(
      userWM.userData.value.data!.user.copyWith(
        email: emailController.text,
      ),
    );
  }
}
