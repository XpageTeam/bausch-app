import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/models/catalog_item/consultattion_item_model.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class ConsultationScreenWM extends WidgetModel {
  final BuildContext context;
  final ConsultationItemModel itemModel;
  final colorState = StreamedState<Color>(AppTheme.mystic);

  late int difference;

  ConsultationScreenWM({
    required this.context,
    required this.itemModel,
  }) : super(const WidgetModelDependencies());

  @override
  void onLoad() {
    final points = Provider.of<UserWM>(
          context,
          listen: false,
        ).userData.value.data?.balance.available.toInt() ??
        0;

    difference = itemModel.price - points;

    super.onLoad();
  }
}
