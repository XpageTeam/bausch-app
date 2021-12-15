// ignore_for_file: unused_import

import 'package:bausch/models/catalog_item/consultattion_item_model.dart';
import 'package:bausch/models/sheets/base_catalog_sheet_model.dart';
import 'package:bausch/models/sheets/catalog_sheet_without_logos_model.dart';
import 'package:bausch/sections/home/widgets/containers/container_interface.dart';
import 'package:bausch/sections/home/widgets/containers/white_container_with_rounded_corners.dart';
import 'package:bausch/sections/sheets/cubit/catalog_item_cubit.dart';
import 'package:bausch/sections/sheets/sheet_methods.dart';
import 'package:bausch/sections/sheets/widgets/listeners/sheet_listener.dart';
import 'package:bausch/test/models.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WideContainerWithoutItems extends StatefulWidget
    implements ContainerInterface {
  final String? subtitle;

  @override
  final CatalogSheetWithoutLogosModel model;

  const WideContainerWithoutItems({
    required this.model,
    this.subtitle,
    Key? key,
  }) : super(key: key);

  @override
  State<WideContainerWithoutItems> createState() =>
      _WideContainerWithoutItemsState();
}

class _WideContainerWithoutItemsState extends State<WideContainerWithoutItems> {
  late CatalogItemCubit catalogItemCubit;

  @override
  void initState() {
    super.initState();
    catalogItemCubit = CatalogItemCubit(section: widget.model.type);
  }

  @override
  void dispose() {
    super.dispose();
    catalogItemCubit.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => catalogItemCubit,
      child: SheetListener(
        model: widget.model,
        child: WhiteContainerWithRoundedCorners(
          onTap: () {
            catalogItemCubit.loadData();
          },
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.model.name,
                style: AppStyles.h2Bold,
              ),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      widget.subtitle ??
                          'Скидка на выбранный товар будет дейстовать в любой из оптик сети',
                      style: AppStyles.p1,
                    ),
                  ),
                  Image.asset(
                    setTheImg(widget.model.type),
                    height: 45,
                  ),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}