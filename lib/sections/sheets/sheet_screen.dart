// ignore_for_file: avoid_bool_literals_in_conditional_expressions

import 'package:another_flushbar/flushbar.dart';
import 'package:bausch/models/catalog_item/catalog_item_model.dart';
import 'package:bausch/models/sheets/base_catalog_sheet_model.dart';
import 'package:bausch/sections/loader/widgets/animated_loader.dart';
import 'package:bausch/sections/sheets/cubit/catalog_item_cubit.dart';
import 'package:bausch/sections/sheets/widgets/listeners/sheet_listener.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/catalog_item/catalog_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SheetScreenArguments {
  final CatalogItemModel model;

  SheetScreenArguments({required this.model});
}

//* Главный экран с элементами каталога
//* С него происходит переход в нужные секции
class SheetScreen extends StatefulWidget {
  final ScrollController controller;

  final BaseCatalogSheetModel sheetModel;

  //final String path;
  const SheetScreen({
    required this.sheetModel,
    required this.controller,
    // required this.path,
    Key? key,
  }) : super(key: key);

  @override
  State<SheetScreen> createState() => _SheetScreenState();
}

class _SheetScreenState extends State<SheetScreen> {
  late CatalogItemCubit catalogItemCubit =
      CatalogItemCubit(section: widget.sheetModel.type);

  @override
  void dispose() {
    super.dispose();
    catalogItemCubit.close();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(5),
        topRight: Radius.circular(5),
      ),
      child: Scaffold(
        body: BlocProvider.value(
          value: catalogItemCubit,
          child: SheetListener(
            child: BlocBuilder<CatalogItemCubit, CatalogItemState>(
              bloc: catalogItemCubit,
              builder: (context, state) {
                debugPrint(state.toString());
                if (state is CatalogItemSuccess) {
                  return CustomScrollView(
                    controller: widget.controller,
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 20,
                        ),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate(
                            [
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/free-packaging.png',
                                    height: 60,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Flexible(
                                    child: Text(
                                      widget.sheetModel.name,
                                      style: AppStyles.h2,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.only(
                          left: 12,
                          right: 12,
                          bottom: 40,
                        ),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, i) => IntrinsicHeight(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CatalogItem(
                                    //context,
                                    model: state.items[i * 2],
                                    isProduct: widget.sheetModel.type !=
                                            StaticData.types['webinar']
                                        ? true
                                        : false,
                                    onTap: () {
                                      Keys.bottomSheetItemsNav.currentState!
                                          .pushNamed(
                                        '/${widget.sheetModel.type}',
                                        arguments: SheetScreenArguments(
                                          model: state.items[i * 2],
                                        ),
                                      );
                                    },
                                  ),
                                  if (state.items
                                      .asMap()
                                      .containsKey(i * 2 + 1))
                                    CatalogItem(
                                      //context,
                                      model: state.items[i * 2 + 1],
                                      isProduct: widget.sheetModel.type !=
                                              StaticData.types['webinar']
                                          ? true
                                          : false,
                                      onTap: () {
                                        Keys.bottomSheetItemsNav.currentState!
                                            .pushNamed(
                                          '/${widget.sheetModel.type}',
                                          arguments: SheetScreenArguments(
                                            model: state.items[i * 2 + 1],
                                          ),
                                        );
                                      },
                                    ),
                                ],
                              ),
                            ),
                            childCount: (state.items.length % 2) == 0
                                ? state.items.length ~/ 2
                                : state.items.length ~/ 2 + 1,
                          ),
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            const SizedBox(
                              height: 60,
                              child: Text(
                                'Имеются противопоказания, необходимо проконсультироваться со специалистом',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  height: 16 / 14,
                                  color: AppTheme.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }

                return const Center(
                  child: AnimatedLoader(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
