import 'package:bausch/global/user/user_wm.dart';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class ProfileSettingsScreenWM extends WidgetModel {
  final BuildContext context;

  final selectedCityName = StreamedState<String?>(null);
  final selectedBirthDate = StreamedState<DateTime?>(null);

  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();

  ProfileSettingsScreenWM({required this.context})
      : super(const WidgetModelDependencies());

  @override
  void onBind() {
    final userWM = Provider.of<UserWM>(context, listen: false);

    selectedCityName.accept(userWM.userData.value.data!.user.city);
    selectedBirthDate.accept(userWM.userData.value.data!.user.birthDate);

    emailController.text = userWM.userData.value.data!.user.email ?? '';
    nameController.text = userWM.userData.value.data!.user.name ?? '';
    lastNameController.text = userWM.userData.value.data!.user.lastName ?? '';
    phoneController.text = userWM.userData.value.data!.user.phone;

    super.onBind();
  }

  @override
  void dispose() {
    super.dispose();

    emailController.dispose();
    nameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
  }

  Future<void> sendUserData() async {
    final userWM = Provider.of<UserWM>(context, listen: false);

    debugPrint(userWM.toString());

    await userWM.updateUserData(
      userWM.userData.value.data!.user.copyWith(
        email: emailController.text,
        name: nameController.text,
        lastName: lastNameController.text,
        phone: phoneController.text,
        city: selectedCityName.value,
        birthDate: selectedBirthDate.value,
      ),
    );
  }

  void setCityName(String? cityName) {
    final userWM = Provider.of<UserWM>(context, listen: false);

    selectedCityName.accept(cityName ?? userWM.userData.value.data!.user.city);
  }

  void setBirthDate(DateTime? birthDate) {
    final userWM = Provider.of<UserWM>(context, listen: false);

    selectedBirthDate
        .accept(birthDate ?? userWM.userData.value.data!.user.birthDate);
  }
}