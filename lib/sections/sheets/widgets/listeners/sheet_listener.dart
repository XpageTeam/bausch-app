import 'package:another_flushbar/flushbar.dart';
import 'package:bausch/models/sheets/base_catalog_sheet_model.dart';
import 'package:bausch/models/sheets/catalog_sheet_model.dart';
import 'package:bausch/sections/loader/widgets/animated_loader.dart';
import 'package:bausch/sections/sheets/cubit/catalog_item_cubit.dart';
import 'package:bausch/sections/sheets/sheet_methods.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
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
        if (state is CatalogItemFailed) {
          Flushbar<void>(
            messageText: Text(
              state.title,
              textAlign: TextAlign.center,
              style: AppStyles.p1White,
            ),
            duration: const Duration(
              seconds: 3,
            ),
            flushbarPosition: FlushbarPosition.TOP,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(5),
              bottomRight: Radius.circular(5),
            ),
          ).show(Keys.mainNav.currentContext!);
        }

        if (state is CatalogItemLoading) {
          showLoader(context);
        }

        if (state is CatalogItemSuccess) {
          Keys.mainNav.currentState!.pop();
          if (model.type == StaticData.types['consultation']) {
            showSheetWithoutItems(context, model, state.items[0]);
          } else {
            showSheetWithItems(context, model, state.items);
          }
        }
      },
      child: child,
    );
  }
}
