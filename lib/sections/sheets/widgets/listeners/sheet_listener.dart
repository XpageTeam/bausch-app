import 'package:bausch/models/catalog_item/catalog_item_model.dart';
import 'package:bausch/models/sheets/base_catalog_sheet_model.dart';
import 'package:bausch/sections/sheets/cubit/catalog_item_cubit.dart';
import 'package:bausch/sections/sheets/sheet_methods.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/widgets/default_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SheetListener extends StatelessWidget {
  final Widget child;
  final BaseCatalogSheetModel model;

  const SheetListener({
    required this.child,
    required this.model,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<CatalogItemCubit, CatalogItemState>(
      listener: (context, state) {
        debugPrint(state.toString());
        if (state is CatalogItemFailed) {
          if (Keys.mainNav.currentState!.canPop()) {
            Keys.mainNav.currentState!.pop();
          }
          showDefaultNotification(
            title: state.title,
          );
        }

        if (state is CatalogItemLoading) {
          showLoader(context);
        }

        if (state is CatalogItemSuccess) {
          if (Keys.mainNav.currentState!.canPop()) {
            Keys.mainNav.currentState!.pop();
            showSheet<List<CatalogItemModel>>(
              context,
              model,
              state.items,
            );
          }
        }
      },
      child: child,
    );
  }
}
