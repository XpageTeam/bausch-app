import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/models/catalog_item/product_item_model.dart';
import 'package:bausch/sections/order_registration/order_registration_screen.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class FreePackagingScreenWM extends WidgetModel {
  final BuildContext context;
  final ProductItemModel productItemModel;

  final buttonAction = VoidAction();

  final colorState = StreamedState<Color>(AppTheme.mystic);

  late int difference;

  FreePackagingScreenWM({
    required this.context,
    required this.productItemModel,
  }) : super(const WidgetModelDependencies());

  @override
  void onLoad() {
    final points = Provider.of<UserWM>(
          context,
          listen: false,
        ).userData.value.data?.balance.available.toInt() ??
        0;
    difference = productItemModel.price - points;

    super.onLoad();
  }

  @override
  void onBind() {
    buttonAction.bind(
      (_) {
        if (difference > 0) {
          Navigator.of(context).pushNamed(
            '/add_points',
          );
        } else {
          Keys.mainNav.currentState!.push<void>(
            MaterialPageRoute(
              builder: (context) {
                return OrderRegistrationScreen(
                  model: productItemModel,
                );
              },
            ),
          );
        }
      },
    );
    super.onBind();
  }
}
