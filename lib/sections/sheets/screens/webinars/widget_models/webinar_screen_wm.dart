import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/models/catalog_item/catalog_item_model.dart';
import 'package:bausch/sections/sheets/sheet_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class WebinarScreenWM extends WidgetModel {
  final BuildContext context;
  final CatalogItemModel itemModel;

  final isEnough = StreamedState<bool>(true);
  final buttonAction = VoidAction();

  late int points;
  late int difference;

  WebinarScreenWM({
    required this.context,
    required this.itemModel,
  }) : super(
          const WidgetModelDependencies(),
        );

  @override
  void onLoad() {
    points = Provider.of<UserWM>(
          context,
          listen: false,
        ).userData.value.data?.balance.available.toInt() ??
        0;

    difference = itemModel.price - points;

    isEnough.accept(difference < 0);

    super.onLoad();
  }

  @override
  void onBind() {
    buttonAction.bind(
      (_) {
        if (isEnough.value) {
          Navigator.of(context).pushNamed(
            '/verification_webinar',
            arguments: ItemSheetScreenArguments(model: itemModel),
          );
        } else {
          // TODO(Nikolay): Здесь возможны проблемы.
          Navigator.of(context).pushReplacementNamed(
            '/add_points',
          );
        }
      },
    );

    super.onBind();
  }
}
