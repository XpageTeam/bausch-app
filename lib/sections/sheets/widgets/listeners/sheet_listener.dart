import 'package:another_flushbar/flushbar.dart';
import 'package:bausch/sections/sheets/cubit/catalog_item_cubit.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SheetListener extends StatelessWidget {
  final Widget child;
  const SheetListener({
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<CatalogItemCubit, CatalogItemState>(
      listener: (context, state) {
        if (state is CatalogItemFailed) {
          Keys.mainNav.currentState!.pop();

          Flushbar<void>(
            messageText: const Text(
              'Что-то пошло не так',
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
      },
      child: child,
    );
  }
}
