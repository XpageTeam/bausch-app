import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/models/catalog_item/product_item_model.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class OrderRegistrationScreenWM extends WidgetModel {
  final BuildContext context;
  final ProductItemModel productItemModel;

  final buttonAction = VoidAction();

  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = MaskedTextController(mask: '+0 000 000 00 00');

  late UserWM userWM;

  late int difference;

  OrderRegistrationScreenWM({
    required this.context,
    required this.productItemModel,
  }) : super(const WidgetModelDependencies());

  @override
  void onLoad() {
    userWM = Provider.of<UserWM>(
      context,
      listen: false,
    );
    final points = userWM.userData.value.data?.balance.available.toInt() ?? 0;
    difference = points - productItemModel.price;

    super.onLoad();
  }

  @override
  void onBind() {
    final userWM = Provider.of<UserWM>(context, listen: false);

    //emailController.text = userWM.userData.value.data!.user.email ?? '';
    nameController.text = userWM.userData.value.data!.user.name ?? '';
    lastNameController.text = userWM.userData.value.data!.user.lastName ?? '';
    phoneController.text = userWM.userData.value.data!.user.phone;

    super.onBind();
  }
}
