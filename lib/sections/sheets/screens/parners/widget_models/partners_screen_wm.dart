import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/models/catalog_item/partners_item_model.dart';
import 'package:bausch/sections/sheets/sheet_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class PartnersScreenWM extends WidgetModel {
  final BuildContext context;
  final PartnersItemModel itemModel;

  final buttonAction = VoidAction();
  bool isEnough = false;
  int difference = 0;

  PartnersScreenWM({
    required this.context,
    required this.itemModel,
  }) : super(
          const WidgetModelDependencies(),
        );

  @override
  void onLoad() {
    final points = Provider.of<UserWM>(
          context,
          listen: false,
        ).userData.value.data?.balance.available.toInt() ??
        0;
    difference = itemModel.price - points;
    isEnough = difference <= 0;

    super.onLoad();
  }

  @override
  void onBind() {
    buttonAction.bind((p0) {
      if (isEnough) {
        Navigator.of(context).pushNamed(
          '/verification_partners',
          arguments: ItemSheetScreenArguments(model: itemModel),
        );
      } else {
        Navigator.of(context).pushNamed(
          '/add_points',
        );
      }
    });
  }
}
