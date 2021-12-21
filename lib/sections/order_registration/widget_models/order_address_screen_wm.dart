import 'package:bausch/models/catalog_item/product_item_model.dart';
import 'package:bausch/models/profile_settings/adress_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class OrderAddressScreenWM extends WidgetModel {
  final BuildContext context;

  final AdressModel adress;

  //final TextEditingController flatCon;

  //final ProductItemModel productItemModel;
  OrderAddressScreenWM({
    required this.context,
    required this.adress,
    //required this.productItemModel,
  }) : super(const WidgetModelDependencies());
}
